@extends('admin.layout')

@section('title', 'Dashboard')

@section('content')
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-sm mb-lg">
        <div>
            <h2 class="text-h1 text-on-surface tracking-tight font-bold">Clinical Overview</h2>
            <p class="text-body-md text-on-surface-variant">Real-time performance metrics and system alerts.</p>
        </div>
        <div class="flex gap-sm">
            <button class="flex items-center gap-xs px-sm py-sm bg-white border border-outline-variant text-on-surface-variant rounded-lg text-[11px] font-bold hover:bg-surface-container-low transition-colors">
                <span class="material-symbols-outlined text-[18px]">calendar_today</span>
                Last 24 Hours
            </button>
            <button class="flex items-center gap-xs px-sm py-sm bg-primary-container text-white rounded-lg text-[11px] font-bold hover:brightness-90 transition-all shadow-sm">
                <span class="material-symbols-outlined text-[18px]">download</span>
                Export Report
            </button>
        </div>
    </div>

    <!-- Bento Metrics Grid -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-md mb-lg">
        <div class="bg-white border border-outline-variant p-md rounded-xl space-y-sm hover:border-primary-fixed transition-colors">
            <div class="flex justify-between items-start">
                <div class="p-xs bg-surface-container-low rounded-lg text-primary">
                    <span class="material-symbols-outlined">payments</span>
                </div>
                <span class="text-green-600 text-[11px] font-bold flex items-center bg-green-50 px-xs py-base rounded">+12.5%</span>
            </div>
            <div>
                <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Total Revenue</p>
                <h3 class="text-h2 text-on-surface font-bold">TZS {{ number_format($stats['total_revenue'] ?? 0, 0) }}</h3>
            </div>
        </div>
        <div class="bg-white border border-outline-variant p-md rounded-xl space-y-sm hover:border-primary-fixed transition-colors">
            <div class="flex justify-between items-start">
                <div class="p-xs bg-surface-container-low rounded-lg text-primary">
                    <span class="material-symbols-outlined">shopping_bag</span>
                </div>
                <span class="text-on-surface-variant text-[11px] font-bold px-xs py-base">Ongoing</span>
            </div>
            <div>
                <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Active Orders</p>
                <h3 class="text-h2 text-on-surface font-bold">{{ $stats['total_orders'] }}</h3>
            </div>
        </div>
        <div class="bg-white border border-outline-variant p-md rounded-xl space-y-sm border-l-4 border-l-primary-container">
            <div class="flex justify-between items-start">
                <div class="p-xs bg-error-container rounded-lg text-primary">
                    <span class="material-symbols-outlined">warning</span>
                </div>
                <span class="text-error text-[11px] font-bold bg-error-container px-sm py-base rounded-full uppercase">Critical</span>
            </div>
            <div>
                <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Inventory Alerts</p>
                <h3 class="text-h2 text-on-surface font-bold">{{ $stats['low_stock_count'] ?? 0 }} <span class="text-h3 font-normal text-on-surface-variant">Low Stock</span></h3>
            </div>
        </div>
        <div class="bg-white border border-outline-variant p-md rounded-xl space-y-sm hover:border-primary-fixed transition-colors">
            <div class="flex justify-between items-start">
                <div class="p-xs bg-surface-container-low rounded-lg text-primary">
                    <span class="material-symbols-outlined">pending_actions</span>
                </div>
                <span class="text-primary text-[11px] font-bold bg-primary-fixed px-xs py-base rounded">Pending</span>
            </div>
            <div>
                <p class="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Pending Orders</p>
                <h3 class="text-h2 text-on-surface font-bold">{{ $stats['pending_orders'] }}</h3>
            </div>
        </div>
    </div>

    <!-- Dashboard Split Layout -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-md">
        <!-- Recent Activity Feed -->
        <div class="lg:col-span-2 bg-white border border-outline-variant rounded-xl overflow-hidden">
            <div class="px-md py-sm border-b border-outline-variant flex justify-between items-center">
                <h4 class="text-h3 text-on-surface font-semibold">Recent Orders</h4>
                <a href="{{ route('admin.orders.index') }}" class="text-primary text-[11px] font-bold hover:underline">View All</a>
            </div>
            <div class="divide-y divide-outline-variant">
                @forelse($recentOrders as $order)
                    <div class="p-md flex items-start gap-md hover:bg-surface-container-lowest transition-colors">
                        <div class="w-10 h-10 rounded-full bg-surface-container-low flex items-center justify-center shrink-0">
                            @if($order->status === 'delivered')
                                <span class="material-symbols-outlined text-primary">check_circle</span>
                            @elseif($order->status === 'cancelled')
                                <span class="material-symbols-outlined text-error">cancel</span>
                            @else
                                <span class="material-symbols-outlined text-primary">pending</span>
                            @endif
                        </div>
                        <div class="flex-1">
                            <p class="text-body-md text-on-surface">
                                Order <span class="font-bold text-primary">#{{ $order->order_number }}</span>
                                status updated to
                                <span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase inline-block
                                    @if($order->status === 'delivered') bg-green-100 text-green-800
                                    @elseif($order->status === 'cancelled') bg-red-100 text-red-800
                                    @elseif($order->status === 'shipped') bg-blue-100 text-blue-800
                                    @elseif($order->status === 'processing') bg-yellow-100 text-yellow-800
                                    @else bg-gray-100 text-gray-800 @endif">
                                    {{ $order->status }}
                                </span>
                            </p>
                            <p class="text-[11px] text-on-surface-variant font-medium mt-1">{{ $order->user->name }} • {{ $order->created_at->diffForHumans() }}</p>
                        </div>
                    </div>
                @empty
                    <div class="p-md text-center text-on-surface-variant text-sm">No recent orders</div>
                @endforelse
            </div>
        </div>
        <!-- Secondary Column -->
        <div class="space-y-md">
            <!-- Pending Verifications -->
            <div class="bg-white border border-outline-variant rounded-xl p-md">
                <div class="flex justify-between items-center mb-md">
                    <h4 class="text-[11px] font-bold uppercase tracking-widest text-on-surface-variant">Pending Verifications</h4>
                    <span class="material-symbols-outlined text-primary">verified</span>
                </div>
                @forelse($pendingDocuments as $doc)
                    <div class="flex items-center justify-between p-sm bg-surface-container-low rounded-lg mb-sm">
                        <div>
                            <p class="text-[11px] font-bold text-on-surface">{{ $doc->user->business_name ?? $doc->user->name }}</p>
                            <p class="text-[10px] text-on-surface-variant font-medium">{{ strtoupper($doc->document_type) }}</p>
                        </div>
                        <a href="{{ route('admin.documents.review', $doc->id) }}" class="text-[10px] font-bold text-primary hover:underline">Review</a>
                    </div>
                @empty
                    <p class="text-sm text-on-surface-variant text-center py-4">No pending verifications</p>
                @endforelse
            </div>
            <!-- Users Summary -->
            <div class="bg-white border border-outline-variant rounded-xl overflow-hidden">
                <div class="p-md border-b border-outline-variant">
                    <h4 class="text-[11px] font-bold uppercase tracking-widest text-on-surface-variant">Platform Summary</h4>
                </div>
                <div class="p-md space-y-sm">
                    <div class="flex justify-between items-center">
                        <span class="text-sm text-on-surface-variant">Total Users</span>
                        <span class="text-sm font-bold text-on-surface">{{ $stats['total_users'] }}</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-sm text-on-surface-variant">Verified Businesses</span>
                        <span class="text-sm font-bold text-green-600">{{ $stats['verified_businesses'] }}</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-sm text-on-surface-variant">Total Products</span>
                        <span class="text-sm font-bold text-on-surface">{{ $stats['total_products'] }}</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-sm text-on-surface-variant">Pending Docs</span>
                        <span class="text-sm font-bold text-yellow-600">{{ $stats['pending_documents'] }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
