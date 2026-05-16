@extends('admin.layout')

@section('title', 'All Documents')

@section('content')
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-md mb-lg">
        <div>
            <h1 class="text-h1 text-on-surface tracking-tight font-bold">All Documents</h1>
            <p class="text-body-md text-on-surface-variant">Manage verification documents across all statuses.</p>
        </div>
        <a href="{{ route('admin.documents.pending') }}" class="flex items-center gap-xs px-md py-sm bg-yellow-600 text-white rounded-lg text-[11px] font-bold hover:bg-yellow-700 transition-colors">
            <span class="material-symbols-outlined text-[18px]">pending_actions</span>
            View Pending Only
        </a>
    </div>

    <!-- Filters -->
    <div class="bg-white border border-outline-variant rounded-xl p-md mb-lg">
        <form method="GET" class="flex flex-wrap gap-md items-end">
            <div>
                <label class="block text-[11px] font-bold text-on-surface-variant mb-1">Status</label>
                <select name="status" class="border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary outline-none">
                    <option value="all">All Status</option>
                    <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                    <option value="approved" {{ request('status') == 'approved' ? 'selected' : '' }}>Approved</option>
                    <option value="rejected" {{ request('status') == 'rejected' ? 'selected' : '' }}>Rejected</option>
                </select>
            </div>
            <button type="submit" class="bg-primary-container text-on-primary px-md py-sm rounded-lg text-[11px] font-bold hover:bg-primary transition-colors">Filter</button>
        </form>
    </div>

    <!-- Documents Table -->
    <div class="bg-white border border-outline-variant rounded-xl overflow-hidden shadow-sm">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse zebra-table">
                <thead>
                    <tr class="bg-surface-container-low border-b border-outline-variant">
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Business</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Type</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Status</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Date</th>
                        <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="text-sm text-on-surface">
                    @foreach($documents as $doc)
                        <tr class="border-b border-outline-variant hover:bg-surface-container-low transition-colors">
                            <td class="px-md py-md">
                                <p class="text-sm font-semibold text-on-surface">{{ $doc->user->business_name ?? $doc->user->name }}</p>
                                <p class="text-[11px] text-on-surface-variant">{{ $doc->user->email }}</p>
                            </td>
                            <td class="px-md py-md">
                                <span class="px-2 py-0.5 text-[10px] font-bold rounded bg-primary-fixed text-primary">{{ strtoupper($doc->document_type) }}</span>
                            </td>
                            <td class="px-md py-md">
                                <span class="px-2 py-0.5 text-[10px] font-bold rounded
                                    @if($doc->status == 'approved') bg-green-100 text-green-700
                                    @elseif($doc->status == 'rejected') bg-red-100 text-red-700
                                    @else bg-yellow-100 text-yellow-700 @endif">
                                    {{ ucfirst($doc->status) }}
                                </span>
                            </td>
                            <td class="px-md py-md text-on-surface-variant">{{ $doc->created_at->format('M d, Y') }}</td>
                            <td class="px-md py-md text-right">
                                <a href="{{ route('admin.documents.review', $doc->id) }}" class="inline-flex items-center gap-xs text-primary text-[11px] font-bold hover:underline">
                                    <span class="material-symbols-outlined text-[16px]">visibility</span>
                                    {{ $doc->status == 'pending' ? 'Review' : 'View' }}
                                </a>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
        <div class="px-md py-sm flex items-center justify-between border-t border-outline-variant bg-surface-container-lowest">
            <span class="text-sm text-on-surface-variant">Showing {{ $documents->firstItem() ?? 0 }} to {{ $documents->lastItem() ?? 0 }} of {{ $documents->total() }} entries</span>
            <div>{{ $documents->links() }}</div>
        </div>
    </div>
@endsection
