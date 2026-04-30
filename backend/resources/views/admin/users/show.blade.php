@extends('admin.layout')

@section('title', 'View User - ' . $user->name)

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.users.index') }}" class="text-primary hover:underline">← Back to Users</a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- User Info -->
        <div class="lg:col-span-1">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="text-center mb-6">
                    <div class="w-20 h-20 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
                        <span class="text-2xl text-white font-bold">{{ substr($user->name, 0, 1) }}</span>
                    </div>
                    <h2 class="text-xl font-bold">{{ $user->name }}</h2>
                    <p class="text-gray-600">{{ $user->email }}</p>
                </div>

                <div class="space-y-3">
                    <div class="flex justify-between">
                        <span class="text-gray-600">Role</span>
                        <span class="font-medium">{{ ucfirst($user->role) }}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-gray-600">Status</span>
                        @if($user->is_verified)
                            <span class="text-green-600 font-medium">Verified</span>
                        @else
                            <span class="text-yellow-600 font-medium">Unverified</span>
                        @endif
                    </div>
                    @if($user->business_name)
                        <div class="flex justify-between">
                            <span class="text-gray-600">Business</span>
                            <span class="font-medium">{{ $user->business_name }}</span>
                        </div>
                    @endif
                    @if($user->phone)
                        <div class="flex justify-between">
                            <span class="text-gray-600">Phone</span>
                            <span class="font-medium">{{ $user->phone }}</span>
                        </div>
                    @endif
                </div>

                <div class="mt-6 space-y-3">
                    @if(!$user->is_verified && $user->role === 'business')
                        <form method="POST" action="{{ route('admin.users.verify', $user->id) }}">
                            @csrf
                            <button type="submit" class="w-full bg-green-600 text-white py-2 rounded hover:bg-green-700">
                                Verify Business
                            </button>
                        </form>
                    @endif

                    @if($user->is_verified)
                        <form method="POST" action="{{ route('admin.users.unverify', $user->id) }}">
                            @csrf
                            <button type="submit" class="w-full bg-yellow-600 text-white py-2 rounded hover:bg-yellow-700">
                                Remove Verification
                            </button>
                        </form>
                    @endif
                </div>
            </div>
        </div>

        <!-- Documents and Orders -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Documents -->
            <div class="bg-white rounded-lg shadow">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold">Verification Documents</h3>
                </div>
                <div class="p-6">
                    @if($documents->count() > 0)
                        @foreach($documents as $doc)
                            <div class="flex items-center justify-between py-3 {{ !$loop->last ? 'border-b border-gray-100' : '' }}">
                                <div>
                                    <p class="font-medium">{{ strtoupper($doc->document_type) }} Certificate</p>
                                    <p class="text-sm text-gray-600">{{ $doc->created_at->format('M d, Y') }}</p>
                                </div>
                                <span class="px-2 py-1 text-xs rounded-full
                                    @if($doc->status == 'approved') bg-green-100 text-green-800
                                    @elseif($doc->status == 'rejected') bg-red-100 text-red-800
                                    @else bg-yellow-100 text-yellow-800
                                    @endif">
                                    {{ ucfirst($doc->status) }}
                                </span>
                            </div>
                        @endforeach
                    @else
                        <p class="text-gray-500 text-center py-4">No documents uploaded</p>
                    @endif
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="bg-white rounded-lg shadow">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold">Recent Orders</h3>
                </div>
                <div class="p-6">
                    @if($orders->count() > 0)
                        @foreach($orders as $order)
                            <div class="flex items-center justify-between py-3 {{ !$loop->last ? 'border-b border-gray-100' : '' }}">
                                <div>
                                    <p class="font-medium">{{ $order->order_number }}</p>
                                    <p class="text-sm text-gray-600">TZS {{ number_format($order->total_amount, 0) }}</p>
                                </div>
                                <span class="px-2 py-1 text-xs rounded-full
                                    @if($order->status == 'delivered') bg-green-100 text-green-800
                                    @elseif($order->status == 'cancelled') bg-red-100 text-red-800
                                    @else bg-gray-100 text-gray-800
                                    @endif">
                                    {{ ucfirst($order->status) }}
                                </span>
                            </div>
                        @endforeach
                    @else
                        <p class="text-gray-500 text-center py-4">No orders yet</p>
                    @endif
                </div>
            </div>
        </div>
    </div>
@endsection
