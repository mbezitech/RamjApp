@extends('admin.layout')

@section('title', 'Orders')

@section('content')
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-md mb-xl">
        <div>
            <h1 class="text-h1 text-on-surface tracking-tight font-bold">Order Oversight</h1>
            <p class="text-body-md text-on-surface-variant">Master log of clinical orders across all registered facilities.</p>
        </div>
        <div class="flex items-center gap-sm">
            <button class="flex items-center gap-xs px-md py-sm bg-white border border-outline-variant rounded-lg text-on-surface-variant text-[11px] font-bold hover:bg-surface-container-low transition-colors">
                <span class="material-symbols-outlined text-[18px]">filter_list</span>
                Advanced Filters
            </button>
            <button class="flex items-center gap-xs px-md py-sm bg-primary-container text-on-primary rounded-lg text-[11px] font-bold hover:bg-primary transition-colors shadow-sm">
                <span class="material-symbols-outlined text-[18px]">ios_share</span>
                Export Report
            </button>
        </div>
    </div>

    <!-- Stats Bar -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-md mb-lg">
        @php
            $totalOrders = \App\Models\Order::count();
            $processingCount = \App\Models\Order::where('status', 'processing')->count();
            $shippedCount = \App\Models\Order::where('status', 'shipped')->count();
            $monthRevenue = \App\Models\Order::where('status', 'delivered')
                ->whereMonth('created_at', now()->month)
                ->sum('total_amount');
        @endphp
        <div class="bg-white border border-outline-variant p-md rounded-xl">
            <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">Total Orders</p>
            <h3 class="text-h3 text-on-surface font-semibold">{{ number_format($totalOrders) }}</h3>
        </div>
        <div class="bg-white border border-outline-variant p-md rounded-xl">
            <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">Processing</p>
            <h3 class="text-h3 text-secondary font-semibold">{{ $processingCount }}</h3>
        </div>
        <div class="bg-white border border-outline-variant p-md rounded-xl">
            <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">In Transit</p>
            <h3 class="text-h3 text-primary font-semibold">{{ $shippedCount }}</h3>
        </div>
        <div class="bg-white border border-outline-variant p-md rounded-xl">
            <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">Revenue (MTD)</p>
            <h3 class="text-h3 text-on-surface font-semibold">TZS {{ number_format($monthRevenue, 0) }}</h3>
        </div>
    </div>

    <!-- Filters -->
    <div class="bg-white border border-outline-variant rounded-xl p-md mb-lg flex flex-wrap gap-md items-center">
        <div class="flex-1 min-w-[200px]">
            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">Search Orders</label>
            <div class="relative">
                <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-on-surface-variant text-[18px]">search</span>
                <input class="w-full pl-xl pr-md py-sm border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary outline-none text-sm" placeholder="Order ID or customer name..." type="text">
            </div>
        </div>
        <form method="GET" class="contents">
            <div>
                <label class="block text-[11px] font-bold text-on-surface-variant mb-1">Status</label>
                <select name="status" class="px-sm py-sm border border-outline-variant rounded-lg text-sm outline-none focus:ring-2 focus:ring-primary">
                    <option value="all">All Statuses</option>
                    <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                    <option value="processing" {{ request('status') == 'processing' ? 'selected' : '' }}>Processing</option>
                    <option value="shipped" {{ request('status') == 'shipped' ? 'selected' : '' }}>Shipped</option>
                    <option value="delivered" {{ request('status') == 'delivered' ? 'selected' : '' }}>Delivered</option>
                    <option value="cancelled" {{ request('status') == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                </select>
            </div>
            <button type="submit" class="px-md py-sm bg-primary-container text-on-primary rounded-lg text-[11px] font-bold hover:bg-primary transition-colors mt-5">Filter</button>
        </form>
    </div>

    <!-- Orders Table -->
    <div class="bg-white border border-outline-variant rounded-xl overflow-hidden shadow-sm">
        <table class="w-full text-left border-collapse zebra-table">
            <thead>
                <tr class="border-b border-outline-variant bg-surface-container-low">
                    <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Order ID</th>
                    <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Customer</th>
                    <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Date</th>
                    <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Amount</th>
                    <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Status</th>
                    <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider text-right">Actions</th>
                </tr>
            </thead>
            <tbody class="text-sm text-on-surface">
                @forelse($orders as $order)
                    <tr class="border-b border-outline-variant hover:bg-surface-container-low transition-colors">
                        <td class="px-md py-md font-bold">#{{ $order->order_number }}</td>
                        <td class="px-md py-md text-on-surface-variant">{{ $order->user->name }}</td>
                        <td class="px-md py-md text-on-surface-variant">{{ $order->created_at->format('M d, Y') }}</td>
                        <td class="px-md py-md font-medium">TZS {{ number_format($order->total_amount, 0) }}</td>
                        <td class="px-md py-md">
                            <span class="px-2 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider inline-block
                                @if($order->status === 'delivered') bg-green-100 text-green-700
                                @elseif($order->status === 'cancelled') bg-red-100 text-red-700
                                @elseif($order->status === 'shipped') bg-primary/10 text-primary
                                @elseif($order->status === 'processing') bg-secondary/10 text-secondary
                                @else bg-gray-100 text-gray-700 @endif">
                                {{ $order->status }}
                            </span>
                        </td>
                        <td class="px-md py-md text-right">
                            <a href="{{ route('admin.orders.show', $order->id) }}" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-primary transition-colors rounded hover:bg-surface-container-low" title="View">
                                <span class="material-symbols-outlined text-[18px]">visibility</span>
                            </a>
                            @if($order->status === 'pending')
                                <form method="POST" action="{{ route('admin.orders.update-status', $order->id) }}" class="inline" onsubmit="return confirm('Process this order?')">
                                    @csrf
                                    <input type="hidden" name="status" value="processing">
                                    <button type="submit" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-primary transition-colors rounded hover:bg-surface-container-low" title="Process">
                                        <span class="material-symbols-outlined text-[18px]">play_arrow</span>
                                    </button>
                                </form>
                            @endif
                            <button class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-primary transition-colors rounded hover:bg-surface-container-low" title="More">
                                <span class="material-symbols-outlined text-[18px]">more_vert</span>
                            </button>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="6" class="px-md py-lg text-center text-on-surface-variant">No orders found</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="px-md py-sm flex items-center justify-between border-t border-outline-variant bg-surface-container-lowest">
            <span class="text-sm text-on-surface-variant">Showing {{ $orders->firstItem() ?? 0 }} to {{ $orders->lastItem() ?? 0 }} of {{ $orders->total() }} entries</span>
            <div class="flex items-center gap-xs">
                {{ $orders->links() }}
            </div>
        </div>
    </div>

    <!-- Support Info Grid -->
    <div class="mt-xl grid grid-cols-1 md:grid-cols-12 gap-lg">
        <div class="md:col-span-8 bg-surface-container-low p-lg rounded-xl flex items-center gap-lg">
            <div class="w-16 h-16 rounded-lg bg-primary-container flex-shrink-0 flex items-center justify-center">
                <span class="material-symbols-outlined text-[36px] text-white" style="font-variation-settings: 'FILL' 1;">quick_reference_all</span>
            </div>
            <div>
                <h3 class="text-h3 text-on-surface font-semibold mb-1">Need an emergency export?</h3>
                <p class="text-sm text-on-surface-variant mb-md">Daily automated audits are generated at 00:00 UTC. Use the export tool for real-time clinical logs.</p>
                <span class="text-primary text-[11px] font-bold flex items-center gap-xs hover:gap-sm transition-all cursor-pointer">
                    Access Secure Portal <span class="material-symbols-outlined text-[16px]">arrow_forward</span>
                </span>
            </div>
        </div>
        <div class="md:col-span-4 bg-white border border-outline-variant p-lg rounded-xl">
            <h3 class="text-h3 text-on-surface font-semibold mb-md">System Health</h3>
            <div class="space-y-sm">
                <div class="flex justify-between items-center">
                    <span class="text-sm">Inventory Sync</span>
                    <span class="w-2 h-2 rounded-full bg-green-500"></span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-sm">Facility API</span>
                    <span class="w-2 h-2 rounded-full bg-green-500"></span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-sm">Logistics Node</span>
                    <span class="w-2 h-2 rounded-full bg-primary"></span>
                </div>
            </div>
        </div>
    </div>
@endsection
