<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $query = Product::where('is_active', true);

        $user = $request->user();
        $canAccessMedicines = $user && $user->canAccessMedicines();

        if (!$canAccessMedicines) {
            $query->where('requires_verification', false);
        }

        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        if ($request->has('in_stock') && $request->in_stock === 'true') {
            $query->where('stock', '>', 0);
        }

        if ($request->has('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('name', 'like', '%' . $request->search . '%')
                  ->orWhere('description', 'like', '%' . $request->search . '%');
            });
        }

        $sort = $request->get('sort', 'name');
        switch ($sort) {
            case 'price_low':
                $query->orderBy('price', 'asc');
                break;
            case 'price_high':
                $query->orderBy('price', 'desc');
                break;
            case 'newest':
                $query->orderBy('created_at', 'desc');
                break;
            default:
                $query->orderBy('name', 'asc');
        }

        $products = $query->orderBy('name')->paginate($request->get('per_page', 20));

        return response()->json([
            'products' => $products->getCollection()->map(function ($product) use ($canAccessMedicines) {
                return [
                    'id' => $product->id,
                    'name' => $product->name,
                    'description' => $product->description,
                    'category' => $product->category,
                    'price' => $product->price,
                    'stock' => $product->stock,
                    'image_url' => $product->image_url,
                    'requires_verification' => $product->requires_verification,
                ];
            }),
            'current_page' => $products->currentPage(),
            'last_page' => $products->lastPage(),
            'total' => $products->total(),
            'can_access_medicines' => $canAccessMedicines,
        ]);
    }

    public function show(Request $request, Product $product)
    {
        $user = $request->user();

        if ($product->requires_verification && (!$user || !$user->canAccessMedicines())) {
            return response()->json([
                'message' => 'Access denied. This product requires business verification.',
            ], 403);
        }

        return response()->json([
            'product' => [
                'id' => $product->id,
                'name' => $product->name,
                'description' => $product->description,
                'category' => $product->category,
                'price' => $product->price,
                'stock' => $product->stock,
                'image_url' => $product->image_url,
                'requires_verification' => $product->requires_verification,
                'is_active' => $product->is_active,
            ],
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|in:medicine,equipment',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'image_url' => 'nullable|string|max:255',
            'requires_verification' => 'boolean',
            'is_active' => 'boolean',
        ]);

        if ($validated['category'] === 'medicine') {
            $validated['requires_verification'] = true;
        }

        $product = Product::create($validated);

        return response()->json([
            'message' => 'Product created successfully',
            'product' => $product,
        ], 201);
    }

    public function update(Request $request, Product $product)
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'category' => 'sometimes|in:medicine,equipment',
            'price' => 'sometimes|numeric|min:0',
            'stock' => 'sometimes|integer|min:0',
            'image_url' => 'nullable|string|max:255',
            'requires_verification' => 'boolean',
            'is_active' => 'boolean',
        ]);

        $product->update($validated);

        return response()->json([
            'message' => 'Product updated successfully',
            'product' => $product,
        ]);
    }

    public function destroy(Product $product)
    {
        $product->delete();

        return response()->json([
            'message' => 'Product deleted successfully',
        ]);
    }
}
