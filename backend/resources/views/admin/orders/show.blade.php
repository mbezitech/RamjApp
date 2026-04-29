@extends('admin.layout')

@section('title', 'Order - ' . $order->order_number)

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.orders.index') }}" class="text-blue-600 hover:underline">← Back to Orders</a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Order Info -->
        <div class="lg:col-span-2 space-y-6">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex justify-between items-start mb-4">
                    <div>
                        <h2 class="text-xl font-bold">{{ $order->order_number }}</h2>
                        <p class="text-gray-600">{{ $order->created_at->format('F d, Y - h:i A') }}</p>
                    </div>
                    <form method="POST" action="{{ route('admin.orders.update-status', $order->id) }}" class="flex gap-2">
                        @csrf
                        <select name="status" class="border border-gray-300 rounded px-3 py-1">
                            <option value="pending" {{ $order->status == 'pending' ? 'selected' : '' }}>Pending</option>
                            <option value="processing" {{ $order->status == 'processing' ? 'selected' : '' }}>Processing</option>
                            <option value="shipped" {{ $order->status == 'shipped' ? 'selected' : '' }}>Shipped</option>
                            <option value="delivered" {{ $order->status == 'delivered' ? 'selected' : '' }}>Delivered</option>
                            <option value="cancelled" {{ $order->status == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                        </select>
                        <button type="submit" class="bg-blue-600 text-white px-3 py-1 rounded text-sm">
                            Update
                        </button>
                    </form>
                </div>

                <div class="border-t pt-4">
                    <h3 class="font-semibold mb-3">Order Items</h3>
                    @foreach($order->items as $item)
                        <div class="flex justify-between py-3 {{ !$loop->last ? 'border-b border-gray-100' : '' }}">
                            <div>
                                <p class="font-medium">{{ $item->product->name }}</p>
                                <p class="text-sm text-gray-600">Qty: {{ $item->quantity }}</p>
                            </div>
                            <p class="font-medium">TZS {{ number_format($item->subtotal, 0) }}</p>
                        </div>
                    @endforeach
                    <div class="flex justify-between pt-4 border-t border-gray-200 font-bold">
                        <span>Total</span>
                        <span>TZS {{ number_format($order->total_amount, 0) }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Info -->
        <div class="space-y-6">
            <div class="bg-white rounded-lg shadow p-6">
                <h3 class="font-semibold mb-4">Customer</h3>
                <p class="font-medium">{{ $order->user->name }}</p>
                <p class="text-sm text-gray-600">{{ $order->user->email }}</p>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <h3 class="font-semibold mb-4">Shipping Address</h3>
                <p class="text-sm text-gray-600">{{ $order->shipping_address }}</p>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <h3 class="font-semibold mb-4">Payment</h3>
                <p class="text-sm text-gray-600">Method: {{ ucfirst(str_replace('_', ' ', $order->payment_method)) }}</p>
                <p class="text-sm mt-2">
                    Status:
                    <span class="px-2 py-1 text-xs rounded-full
                        @if($order->payment_status == 'paid') bg-green-100 text-green-800
                        @elseif($order->payment_status == 'failed') bg-red-100 text-red-800
                        @else bg-yellow-100 text-yellow-800 @endif">
                        {{ ucfirst($order->payment_status) }}
                    </span>
                </p>
            </div>
        </div>
    </div>
@endsection
