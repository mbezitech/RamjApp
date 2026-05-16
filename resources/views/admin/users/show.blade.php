@extends('admin.layout')

@section('title', 'View User - ' . $user->name)

@section('content')
    <div class="mb-md">
        <a href="{{ route('admin.users.index') }}" class="text-primary text-[11px] font-bold hover:underline inline-flex items-center gap-xs">
            <span class="material-symbols-outlined text-[16px]">arrow_back</span>
            Back to Users
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-lg">
        <!-- User Info -->
        <div class="lg:col-span-1">
            <div class="bg-white border border-outline-variant rounded-xl p-md">
                <div class="text-center mb-md">
                    <div class="w-20 h-20 bg-primary rounded-full flex items-center justify-center mx-auto mb-md">
                        <span class="text-2xl text-white font-bold">{{ substr($user->name, 0, 1) }}</span>
                    </div>
                    <h2 class="text-h3 text-on-surface font-semibold">{{ $user->name }}</h2>
                    <p class="text-sm text-on-surface-variant">{{ $user->email }}</p>
                </div>

                <div class="space-y-3">
                    <div class="flex justify-between">
                        <span class="text-sm text-on-surface-variant">Role</span>
                        <span class="text-sm font-semibold">{{ ucfirst($user->role) }}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-sm text-on-surface-variant">Status</span>
                        <div class="flex gap-1">
                            @if($user->is_verified)
                                <span class="text-[11px] font-bold text-green-600">Verified</span>
                            @else
                                <span class="text-[11px] font-bold text-yellow-600">Unverified</span>
                            @endif
                            @if($user->is_active)
                                <span class="text-[11px] font-bold text-blue-600">· Active</span>
                            @else
                                <span class="text-[11px] font-bold text-red-600">· Suspended</span>
                            @endif
                        </div>
                    </div>
                    @if($user->business_name)
                        <div class="flex justify-between">
                            <span class="text-sm text-on-surface-variant">Business</span>
                            <span class="text-sm font-semibold">{{ $user->business_name }}</span>
                        </div>
                    @endif
                    @if($user->phone)
                        <div class="flex justify-between">
                            <span class="text-sm text-on-surface-variant">Phone</span>
                            <span class="text-sm font-semibold">{{ $user->phone }}</span>
                        </div>
                    @endif
                </div>

                <div class="mt-md space-y-3">
                    @if(!$user->is_verified && $user->role === 'business')
                        <form method="POST" action="{{ route('admin.users.verify', $user->id) }}">
                            @csrf
                            <button type="submit" class="w-full bg-green-600 text-white py-sm rounded-lg text-[11px] font-bold hover:bg-green-700 transition-colors">
                                Verify Business
                            </button>
                        </form>
                    @endif
                    @if($user->is_verified)
                        <form method="POST" action="{{ route('admin.users.unverify', $user->id) }}">
                            @csrf
                            <button type="submit" class="w-full bg-yellow-600 text-white py-sm rounded-lg text-[11px] font-bold hover:bg-yellow-700 transition-colors">
                                Remove Verification
                            </button>
                        </form>
                    @endif
                    @if($user->role !== 'admin')
                        @if($user->is_active)
                            <form method="POST" action="{{ route('admin.users.deactivate', $user->id) }}">
                                @csrf
                                <button type="submit" class="w-full bg-red-600 text-white py-sm rounded-lg text-[11px] font-bold hover:bg-red-700 transition-colors">
                                    Suspend Account
                                </button>
                            </form>
                        @else
                            <form method="POST" action="{{ route('admin.users.activate', $user->id) }}">
                                @csrf
                                <button type="submit" class="w-full bg-green-600 text-white py-sm rounded-lg text-[11px] font-bold hover:bg-green-700 transition-colors">
                                    Activate Account
                                </button>
                            </form>
                        @endif
                        <hr class="border-outline-variant my-md">
                        <form method="POST" action="{{ route('admin.users.role', $user->id) }}">
                            @csrf
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-2">Change Role</label>
                            <select name="role" class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary outline-none mb-2">
                                <option value="customer" {{ $user->role == 'customer' ? 'selected' : '' }}>Customer</option>
                                <option value="business" {{ $user->role == 'business' ? 'selected' : '' }}>Business</option>
                                <option value="admin" {{ $user->role == 'admin' ? 'selected' : '' }}>Admin</option>
                            </select>
                            <button type="submit" class="w-full bg-primary-container text-on-primary py-sm rounded-lg text-[11px] font-bold hover:bg-primary transition-colors">
                                Update Role
                            </button>
                        </form>
                    @endif
                </div>
            </div>
        </div>

        <!-- Documents and Orders -->
        <div class="lg:col-span-2 space-y-lg">
            <!-- Documents -->
            <div class="bg-white border border-outline-variant rounded-xl">
                <div class="px-md py-sm border-b border-outline-variant">
                    <h3 class="text-[15px] font-semibold text-on-surface">Verification Documents</h3>
                </div>
                <div class="p-md">
                    @if($documents->count() > 0)
                        @foreach($documents as $doc)
                            <div class="flex items-center justify-between py-sm {{ !$loop->last ? 'border-b border-outline-variant/50' : '' }}">
                                <div>
                                    <p class="text-sm font-medium text-on-surface">{{ strtoupper($doc->document_type) }} Certificate</p>
                                    <p class="text-[11px] text-on-surface-variant">{{ $doc->created_at->format('M d, Y') }}</p>
                                </div>
                                <span class="px-2 py-0.5 text-[10px] font-bold rounded
                                    @if($doc->status == 'approved') bg-green-100 text-green-700
                                    @elseif($doc->status == 'rejected') bg-red-100 text-red-700
                                    @else bg-yellow-100 text-yellow-700
                                    @endif">
                                    {{ ucfirst($doc->status) }}
                                </span>
                            </div>
                        @endforeach
                    @else
                        <p class="text-sm text-on-surface-variant text-center py-md">No documents uploaded</p>
                    @endif
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="bg-white border border-outline-variant rounded-xl">
                <div class="px-md py-sm border-b border-outline-variant">
                    <h3 class="text-[15px] font-semibold text-on-surface">Recent Orders</h3>
                </div>
                <div class="p-md">
                    @if($orders->count() > 0)
                        @foreach($orders as $order)
                            <div class="flex items-center justify-between py-sm {{ !$loop->last ? 'border-b border-outline-variant/50' : '' }}">
                                <div>
                                    <p class="text-sm font-medium text-on-surface">{{ $order->order_number }}</p>
                                    <p class="text-[11px] text-on-surface-variant">TZS {{ number_format($order->total_amount, 0) }}</p>
                                </div>
                                <span class="px-2 py-0.5 text-[10px] font-bold rounded
                                    @if($order->status == 'delivered') bg-green-100 text-green-700
                                    @elseif($order->status == 'cancelled') bg-red-100 text-red-700
                                    @else bg-gray-100 text-gray-700
                                    @endif">
                                    {{ ucfirst($order->status) }}
                                </span>
                            </div>
                        @endforeach
                    @else
                        <p class="text-sm text-on-surface-variant text-center py-md">No orders yet</p>
                    @endif
                </div>
            </div>
        </div>
    </div>
@endsection
