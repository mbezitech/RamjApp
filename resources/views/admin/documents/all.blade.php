@extends('admin.layout')

@section('title', 'All Documents')

@section('content')
    <div class="mb-6 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">All Documents</h1>
            <p class="text-gray-600">Manage verification documents</p>
        </div>
        <a href="{{ route('admin.documents.pending') }}"
           class="bg-yellow-600 text-white px-4 py-2 rounded hover:bg-yellow-700">
            View Pending Only
        </a>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <form method="GET" class="flex gap-4 items-end">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                <select name="status" class="border border-gray-300 rounded px-3 py-2">
                    <option value="all">All Status</option>
                    <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                    <option value="approved" {{ request('status') == 'approved' ? 'selected' : '' }}>Approved</option>
                    <option value="rejected" {{ request('status') == 'rejected' ? 'selected' : '' }}>Rejected</option>
                </select>
            </div>
            <button type="submit" class="bg-primary text-white px-4 py-2 rounded hover:bg-primary-dark">
                Filter
            </button>
        </form>
    </div>

    <!-- Documents Table -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
        <table class="min-w-full">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Business</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Type</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
                @foreach($documents as $doc)
                    <tr>
                        <td class="px-6 py-4">
                            <div>
                                <p class="font-medium text-gray-900">{{ $doc->user->business_name ?? $doc->user->name }}</p>
                                <p class="text-xs text-gray-500">{{ $doc->user->email }}</p>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                             <span class="px-2 py-1 text-xs rounded-full bg-primary-bg text-primary-text">
                                 {{ strtoupper($doc->document_type) }}
                             </span>
                        </td>
                        <td class="px-6 py-4">
                            <span class="px-2 py-1 text-xs rounded-full
                                @if($doc->status == 'approved') bg-green-100 text-green-800
                                @elseif($doc->status == 'rejected') bg-red-100 text-red-800
                                @else bg-yellow-100 text-yellow-800 @endif">
                                {{ ucfirst($doc->status) }}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600">{{ $doc->created_at->format('M d, Y') }}</td>
                        <td class="px-6 py-4">
                             <a href="{{ route('admin.documents.review', $doc->id) }}"
                                class="text-primary hover:underline text-sm">
                                 @if($doc->status == 'pending') Review @else View @endif
                             </a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <div class="px-6 py-4 border-t border-gray-200">
            {{ $documents->links() }}
        </div>
    </div>
@endsection
