<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $query = $request->user()->orders()->with('items.product');

        if ($request->has('status') && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        if ($request->has('payment_status') && $request->payment_status !== 'all') {
            $query->where('payment_status', $request->payment_status);
        }

        if ($request->has('search') && $request->search !== '') {
            $search = '%' . $request->search . '%';
            $query->where(function ($q) use ($search) {
                $q->where('order_number', 'like', $search)
                  ->orWhere('shipping_address', 'like', $search);
            });
        }

        $sort = $request->get('sort', 'newest');
        switch ($sort) {
            case 'oldest':
                $query->oldest();
                break;
            case 'price_high':
                $query->orderBy('total_amount', 'desc');
                break;
            case 'price_low':
                $query->orderBy('total_amount', 'asc');
                break;
            default:
                $query->latest();
        }

        $orders = $query->paginate(20);

        return response()->json([
            'orders' => $orders->getCollection()->map(function ($order) {
                return $this->formatOrder($order);
            }),
            'current_page' => $orders->currentPage(),
            'last_page' => $orders->lastPage(),
            'total' => $orders->total(),
        ]);
    }

    public function show(Request $request, Order $order)
    {
        if ($order->user_id !== $request->user()->id && $request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Access denied',
            ], 403);
        }

        return response()->json([
            'order' => $this->formatOrder($order->load('items.product')),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|integer|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'shipping_address' => 'required|string',
            'payment_method' => 'required|string',
        ]);

        $user = $request->user();
        $totalAmount = 0;
        $orderItems = [];

        foreach ($validated['items'] as $item) {
            $product = Product::findOrFail($item['product_id']);

            if ($product->requires_verification && !$user->canPurchaseMedicines()) {
                return response()->json([
                    'message' => "Cannot purchase '{$product->name}'. Business verification required.",
                ], 403);
            }

            if ($product->stock < $item['quantity']) {
                return response()->json([
                    'message' => "Insufficient stock for '{$product->name}'. Available: {$product->stock}",
                ], 400);
            }

            $subtotal = $product->price * $item['quantity'];
            $totalAmount += $subtotal;

            $orderItems[] = [
                'product_id' => $product->id,
                'quantity' => $item['quantity'],
                'unit_price' => $product->price,
                'subtotal' => $subtotal,
            ];
        }

        return DB::transaction(function () use ($user, $validated, $totalAmount, $orderItems) {
            $order = Order::create([
                'user_id' => $user->id,
                'total_amount' => $totalAmount,
                'shipping_address' => $validated['shipping_address'],
                'payment_method' => $validated['payment_method'],
                'status' => Order::STATUS_PENDING,
                'payment_status' => Order::PAYMENT_PENDING,
            ]);

            foreach ($orderItems as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item['product_id'],
                    'quantity' => $item['quantity'],
                    'unit_price' => $item['unit_price'],
                    'subtotal' => $item['subtotal'],
                ]);

                Product::where('id', $item['product_id'])
                    ->decrement('stock', $item['quantity']);
            }

            return response()->json([
                'message' => 'Order placed successfully',
                'order' => $this->formatOrder($order->load('items.product')),
            ], 201);
        });
    }

    public function updateStatus(Request $request, Order $order)
    {
        $validated = $request->validate([
            'status' => 'required|in:pending,processing,shipped,delivered,cancelled',
        ]);

        $order->update(['status' => $validated['status']]);

        if ($validated['status'] === Order::STATUS_CANCELLED) {
            foreach ($order->items as $item) {
                $item->product->increment('stock', $item->quantity);
            }
        }

        return response()->json([
            'message' => 'Order status updated',
            'order' => $this->formatOrder($order),
        ]);
    }

    private function formatOrder(Order $order): array
    {
        return [
            'id' => $order->id,
            'order_number' => $order->order_number,
            'status' => $order->status,
            'total_amount' => $order->total_amount,
            'shipping_address' => $order->shipping_address,
            'payment_method' => $order->payment_method,
            'payment_status' => $order->payment_status,
            'items' => $order->items->map(function ($item) {
                return [
                    'id' => $item->id,
                    'product' => [
                        'id' => $item->product->id,
                        'name' => $item->product->name,
                        'image_url' => $item->product->image_url,
                    ],
                    'quantity' => $item->quantity,
                    'unit_price' => $item->unit_price,
                    'subtotal' => $item->subtotal,
                ];
            }),
            'created_at' => $order->created_at,
            'updated_at' => $order->updated_at,
        ];
    }
}
