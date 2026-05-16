@extends('admin.layout')

@section('title', 'Inventory')

@section('content')
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-md mb-xl">
        <div>
            <h2 class="text-h1 text-on-surface tracking-tight font-bold">Inventory Management</h2>
            <p class="text-body-md text-on-surface-variant">Centralized control for clinical equipment and medical supplies.</p>
        </div>
        <a href="{{ route('admin.products.create') }}"
           class="bg-primary-container text-on-primary px-lg py-sm rounded-lg flex items-center justify-center gap-sm text-[11px] font-bold hover:bg-primary transition-colors clinical-shadow">
            <span class="material-symbols-outlined text-[18px]">add</span>
            Add New Product
        </a>
    </div>

    <!-- Filter Bar -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-sm mb-lg">
        <div class="md:col-span-2 bg-white p-sm rounded-xl border border-outline-variant flex items-center gap-sm clinical-shadow">
            <span class="material-symbols-outlined text-on-surface-variant text-[20px]">search</span>
            <input class="w-full bg-transparent border-none focus:ring-0 text-sm outline-none" placeholder="Search equipment by name or category..." type="text">
        </div>
        <form method="GET" class="contents">
            <div class="bg-white p-sm rounded-xl border border-outline-variant flex items-center gap-sm clinical-shadow">
                <span class="material-symbols-outlined text-on-surface-variant text-[20px]">category</span>
                <select name="category" class="w-full bg-transparent border-none focus:ring-0 text-sm appearance-none outline-none">
                    <option value="all">All Categories</option>
                    <option value="medicine" {{ request('category') == 'medicine' ? 'selected' : '' }}>Medicine</option>
                    <option value="equipment" {{ request('category') == 'equipment' ? 'selected' : '' }}>Equipment</option>
                </select>
            </div>
            <div class="bg-white p-sm rounded-xl border border-outline-variant flex items-center gap-sm clinical-shadow">
                <span class="material-symbols-outlined text-on-surface-variant text-[20px]">inventory</span>
                <select name="status" class="w-full bg-transparent border-none focus:ring-0 text-sm appearance-none outline-none">
                    <option value="all">All Status</option>
                    <option value="active" {{ request('status') == 'active' ? 'selected' : '' }}>Active</option>
                    <option value="inactive" {{ request('status') == 'inactive' ? 'selected' : '' }}>Inactive</option>
                </select>
            </div>
            <button type="submit" class="hidden">Filter</button>
        </form>
    </div>

    <!-- Inventory Table -->
    <div class="bg-white rounded-xl border border-outline-variant overflow-hidden clinical-shadow">
        <div class="overflow-x-auto">
            <table class="w-full border-collapse zebra-table text-left">
                <thead class="bg-surface-container-low border-b border-outline-variant">
                    <tr>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Product Name</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Category</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Stock Status</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Quantity</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Price</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant uppercase tracking-wider text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant">
                    @forelse($products as $product)
                        <tr class="hover:bg-surface-container-lowest transition-colors">
                            <td class="px-md py-sm">
                                <div class="flex items-center gap-sm">
                                    <div class="w-10 h-10 rounded bg-background flex items-center justify-center">
                                        <span class="material-symbols-outlined text-primary text-[20px]">
                                            {{ $product->category === 'medicine' ? 'medication' : 'biotech' }}
                                        </span>
                                    </div>
                                    <div>
                                        <p class="text-sm font-semibold text-on-surface">{{ $product->name }}</p>
                                        @if($product->requires_verification)
                                            <span class="text-[10px] text-primary font-medium">Requires Verification</span>
                                        @endif
                                    </div>
                                </div>
                            </td>
                            <td class="px-md py-sm">
                                <span class="bg-secondary-container text-on-secondary-container px-2 py-0.5 rounded text-[10px] font-bold">{{ strtoupper($product->category) }}</span>
                            </td>
                            <td class="px-md py-sm">
                                @if($product->stock > 10)
                                    <span class="bg-emerald-100 text-emerald-800 px-sm py-0.5 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-600"></span> In Stock
                                    </span>
                                @elseif($product->stock > 0)
                                    <span class="bg-amber-100 text-amber-800 px-sm py-0.5 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                                        <span class="w-1.5 h-1.5 rounded-full bg-amber-600"></span> Low Stock
                                    </span>
                                @else
                                    <span class="bg-red-100 text-red-800 px-sm py-0.5 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                                        <span class="w-1.5 h-1.5 rounded-full bg-red-600"></span> Out of Stock
                                    </span>
                                @endif
                            </td>
                            <td class="px-md py-sm text-sm text-on-surface">{{ $product->stock }}</td>
                            <td class="px-md py-sm text-sm text-on-surface">TZS {{ number_format($product->price, 0) }}</td>
                            <td class="px-md py-sm text-right">
                                <a href="{{ route('admin.products.edit', $product->id) }}" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-primary transition-colors rounded hover:bg-surface-container-low">
                                    <span class="material-symbols-outlined text-[18px]">edit</span>
                                </a>
                                <form method="POST" action="{{ route('admin.products.destroy', $product->id) }}" class="inline" onsubmit="return confirm('Delete this product?')">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-error transition-colors rounded hover:bg-surface-container-low">
                                        <span class="material-symbols-outlined text-[18px]">delete</span>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="px-md py-lg text-center text-on-surface-variant text-sm">No products found</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        <div class="px-md py-sm flex items-center justify-between bg-surface-container-lowest border-t border-outline-variant">
            <p class="text-sm text-on-surface-variant">Showing {{ $products->firstItem() ?? 0 }} to {{ $products->lastItem() ?? 0 }} of {{ $products->total() }} items</p>
            <div class="flex items-center gap-base">
                {{ $products->links() }}
            </div>
        </div>
    </div>

    <!-- Bento Metrics Footer -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-md mt-lg">
        <div class="bg-white p-md rounded-xl border border-outline-variant clinical-shadow">
            <div class="flex items-center justify-between mb-sm">
                <h4 class="text-[11px] font-bold text-on-surface-variant uppercase tracking-widest">Critical Alerts</h4>
                <span class="material-symbols-outlined text-error">warning</span>
            </div>
            <p class="text-h2 text-error font-bold">{{ Product::where('stock', '<', 5)->count() }} Items</p>
            <p class="text-sm text-on-surface-variant mt-1">Requiring immediate restock.</p>
        </div>
        <div class="bg-white p-md rounded-xl border border-outline-variant clinical-shadow">
            <div class="flex items-center justify-between mb-sm">
                <h4 class="text-[11px] font-bold text-on-surface-variant uppercase tracking-widest">Inventory Value</h4>
                <span class="material-symbols-outlined text-primary">payments</span>
            </div>
            <p class="text-h2 text-on-surface font-bold">TZS {{ number_format(Product::sum(\DB::raw('price * stock')), 0) }}</p>
            <p class="text-sm text-on-surface-variant mt-1">Estimated current market value.</p>
        </div>
        <div class="bg-white p-md rounded-xl border border-outline-variant clinical-shadow relative overflow-hidden">
            <div class="flex items-center justify-between mb-sm relative z-10">
                <h4 class="text-[11px] font-bold text-on-surface-variant uppercase tracking-widest">Active Products</h4>
                <span class="material-symbols-outlined text-primary">health_and_safety</span>
            </div>
            <p class="text-h2 text-on-surface font-bold relative z-10">{{ Product::where('is_active', true)->count() }}</p>
            <p class="text-sm text-on-surface-variant mt-1 relative z-10">Currently available for order.</p>
            <div class="absolute right-0 bottom-0 opacity-5">
                <span class="material-symbols-outlined text-[120px]">verified</span>
            </div>
        </div>
    </div>
@endsection
