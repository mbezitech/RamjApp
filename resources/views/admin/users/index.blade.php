@extends('admin.layout')

@section('title', 'Users')

@section('content')
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-md mb-lg">
        <div>
            <h1 class="text-h1 text-on-surface tracking-tight font-bold">User Management</h1>
            <p class="text-body-md text-on-surface-variant">Manage registered users, roles, and account status.</p>
        </div>
    </div>

    <!-- Filters -->
    <div class="bg-white border border-outline-variant rounded-xl p-md mb-lg flex flex-wrap gap-md items-end">
        <form method="GET" class="flex flex-wrap gap-md items-end w-full">
            <div>
                <label class="block text-[11px] font-bold text-on-surface-variant mb-1">Role</label>
                <select name="role" class="border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none">
                    <option value="all">All Roles</option>
                    <option value="customer" {{ request('role') == 'customer' ? 'selected' : '' }}>Customer</option>
                    <option value="business" {{ request('role') == 'business' ? 'selected' : '' }}>Business</option>
                    <option value="admin" {{ request('role') == 'admin' ? 'selected' : '' }}>Admin</option>
                </select>
            </div>
            <div>
                <label class="block text-[11px] font-bold text-on-surface-variant mb-1">Verification</label>
                <select name="verified" class="border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none">
                    <option value="all">All</option>
                    <option value="true" {{ request('verified') == 'true' ? 'selected' : '' }}>Verified</option>
                    <option value="false" {{ request('verified') == 'false' ? 'selected' : '' }}>Unverified</option>
                </select>
            </div>
            <button type="submit" class="bg-primary-container text-on-primary px-md py-sm rounded-lg text-[11px] font-bold hover:bg-primary transition-colors">Filter</button>
        </form>
    </div>

    <!-- Users Table -->
    <div class="bg-white border border-outline-variant rounded-xl overflow-hidden shadow-sm">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse zebra-table">
                <thead>
                    <tr class="bg-surface-container-low border-b border-outline-variant">
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Name</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Email</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Role</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Status</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="text-sm text-on-surface">
                    @foreach($users as $user)
                        <tr class="border-b border-outline-variant hover:bg-surface-container-low transition-colors">
                            <td class="px-md py-md">
                                <div class="flex items-center gap-sm">
                                    <div class="w-9 h-9 rounded-full bg-primary-fixed flex items-center justify-center text-primary font-bold shrink-0">{{ substr($user->name, 0, 1) }}</div>
                                    <div>
                                        <p class="text-sm font-semibold text-on-surface">{{ $user->name }}</p>
                                        @if($user->business_name)
                                            <p class="text-[11px] text-on-surface-variant">{{ $user->business_name }}</p>
                                        @endif
                                    </div>
                                </div>
                            </td>
                            <td class="px-md py-md text-on-surface-variant text-sm">{{ $user->email }}</td>
                            <td class="px-md py-md">
                                <span class="px-2 py-0.5 text-[10px] font-bold rounded
                                    @if($user->role == 'admin') bg-purple-100 text-purple-800
                                    @elseif($user->role == 'business') bg-primary-fixed text-primary
                                    @else bg-gray-100 text-gray-700 @endif">
                                    {{ ucfirst($user->role) }}
                                </span>
                            </td>
                            <td class="px-md py-md">
                                <div class="flex flex-wrap gap-1">
                                    @if($user->is_verified)
                                        <span class="px-2 py-0.5 text-[10px] font-bold rounded bg-green-100 text-green-700">Verified</span>
                                    @else
                                        <span class="px-2 py-0.5 text-[10px] font-bold rounded bg-yellow-100 text-yellow-700">Unverified</span>
                                    @endif
                                    @if($user->is_active)
                                        <span class="px-2 py-0.5 text-[10px] font-bold rounded bg-blue-100 text-blue-700">Active</span>
                                    @else
                                        <span class="px-2 py-0.5 text-[10px] font-bold rounded bg-red-100 text-red-700">Suspended</span>
                                    @endif
                                </div>
                            </td>
                            <td class="px-md py-md text-right">
                                <a href="{{ route('admin.users.show', $user->id) }}" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-primary transition-colors rounded hover:bg-surface-container-low" title="View">
                                    <span class="material-symbols-outlined text-[18px]">visibility</span>
                                </a>
                                @if($user->role !== 'admin')
                                    @if($user->is_active)
                                        <form method="POST" action="{{ route('admin.users.deactivate', $user->id) }}" class="inline" onsubmit="return confirm('Suspend this user?')">
                                            @csrf
                                            <button type="submit" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-error transition-colors rounded hover:bg-surface-container-low" title="Suspend">
                                                <span class="material-symbols-outlined text-[18px]">block</span>
                                            </button>
                                        </form>
                                    @else
                                        <form method="POST" action="{{ route('admin.users.activate', $user->id) }}" class="inline" onsubmit="return confirm('Activate this user?')">
                                            @csrf
                                            <button type="submit" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-green-600 transition-colors rounded hover:bg-surface-container-low" title="Activate">
                                                <span class="material-symbols-outlined text-[18px]">check_circle</span>
                                            </button>
                                        </form>
                                    @endif
                                    <form method="POST" action="{{ route('admin.users.destroy', $user->id) }}" class="inline" onsubmit="return confirm('Delete this user?')">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="inline-flex items-center justify-center w-8 h-8 text-on-surface-variant hover:text-error transition-colors rounded hover:bg-surface-container-low" title="Delete">
                                            <span class="material-symbols-outlined text-[18px]">delete</span>
                                        </button>
                                    </form>
                                @endif
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
        <div class="px-md py-sm flex items-center justify-between border-t border-outline-variant bg-surface-container-lowest">
            <span class="text-sm text-on-surface-variant">Showing {{ $users->firstItem() ?? 0 }} to {{ $users->lastItem() ?? 0 }} of {{ $users->total() }} entries</span>
            <div class="flex items-center gap-xs">
                {{ $users->links() }}
            </div>
        </div>
    </div>
@endsection
