@extends('admin.layout')

@section('title', 'Order - ' . $order->order_number)

@section('content')
    <div class="mb-md">
        <a href="{{ route('admin.orders.index') }}" class="text-primary text-[11px] font-bold hover:underline inline-flex items-center gap-xs">
            <span class="material-symbols-outlined text-[16px]">arrow_back</span>
            Back to Orders
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-lg">
        <!-- Order Info -->
        <div class="lg:col-span-2 space-y-lg">
            <div class="bg-white border border-outline-variant rounded-xl p-md">
                <div class="flex justify-between items-start mb-md">
                    <div>
                        <h2 class="text-h3 text-on-surface font-semibold">{{ $order->order_number }}</h2>
                        <p class="text-sm text-on-surface-variant">{{ $order->created_at->format('F d, Y - h:i A') }}</p>
                    </div>
                    <form method="POST" action="{{ route('admin.orders.update-status', $order->id) }}" class="flex gap-2 items-center">
                        @csrf
                        <select name="status" class="border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary outline-none">
                            <option value="pending" {{ $order->status == 'pending' ? 'selected' : '' }}>Pending</option>
                            <option value="processing" {{ $order->status == 'processing' ? 'selected' : '' }}>Processing</option>
                            <option value="shipped" {{ $order->status == 'shipped' ? 'selected' : '' }}>Shipped</option>
                            <option value="delivered" {{ $order->status == 'delivered' ? 'selected' : '' }}>Delivered</option>
                            <option value="cancelled" {{ $order->status == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                        </select>
                        <button type="submit" class="bg-primary-container text-on-primary px-sm py-sm rounded-lg text-[11px] font-bold hover:bg-primary transition-colors">Update</button>
                    </form>
                </div>

                <div class="border-t border-outline-variant pt-md">
                    <h3 class="text-[15px] font-semibold mb-md">Order Items</h3>
                    @foreach($order->items as $item)
                        <div class="flex justify-between py-sm {{ !$loop->last ? 'border-b border-outline-variant/50' : '' }}">
                            <div>
                                <p class="text-sm font-medium text-on-surface">{{ $item->product->name }}</p>
                                <p class="text-[11px] text-on-surface-variant">Qty: {{ $item->quantity }} × TZS {{ number_format($item->unit_price, 0) }}</p>
                            </div>
                            <p class="text-sm font-semibold text-on-surface">TZS {{ number_format($item->subtotal, 0) }}</p>
                        </div>
                    @endforeach
                    <div class="flex justify-between pt-md border-t border-outline-variant font-bold">
                        <span class="text-sm">Total</span>
                        <span class="text-sm">TZS {{ number_format($order->total_amount, 0) }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar Info -->
        <div class="space-y-lg">
            <div class="bg-white border border-outline-variant rounded-xl p-md">
                <h3 class="text-[15px] font-semibold mb-md">Customer</h3>
                <p class="text-sm font-medium text-on-surface">{{ $order->user->name }}</p>
                <p class="text-sm text-on-surface-variant">{{ $order->user->email }}</p>
            </div>

            <div class="bg-white border border-outline-variant rounded-xl p-md">
                <h3 class="text-[15px] font-semibold mb-md">Shipping</h3>
                <p class="text-sm text-on-surface-variant leading-relaxed">{{ $order->shipping_address ?? 'N/A' }}</p>
            </div>

            <div class="bg-white border border-outline-variant rounded-xl p-md">
                <h3 class="text-[15px] font-semibold mb-md">Payment</h3>
                <p class="text-sm text-on-surface-variant">Method: {{ ucfirst(str_replace('_', ' ', $order->payment_method)) }}</p>
                <p class="text-sm mt-2">
                    Status:
                    <span class="px-2 py-0.5 text-[10px] font-bold rounded
                        @if($order->payment_status == 'paid') bg-green-100 text-green-700
                        @elseif($order->payment_status == 'failed') bg-red-100 text-red-700
                        @else bg-yellow-100 text-yellow-700 @endif">
                        {{ ucfirst($order->payment_status) }}
                    </span>
                </p>
            </div>
        </div>
    </div>
@endsection
