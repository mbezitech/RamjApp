@extends('admin.layout')

@section('title', 'Pending Documents')

@section('content')
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-md mb-lg">
        <div>
            <h1 class="text-h1 text-on-surface tracking-tight font-bold">Pending Verifications</h1>
            <p class="text-body-md text-on-surface-variant">Review business verification documents</p>
        </div>
        <div class="flex gap-sm">
            <a href="{{ route('admin.documents.all') }}" class="flex items-center gap-xs px-md py-sm bg-white border border-outline-variant rounded-lg text-on-surface-variant text-[11px] font-bold hover:bg-surface-container-low transition-colors">
                <span class="material-symbols-outlined text-[18px]">description</span>
                View All Documents
            </a>
        </div>
    </div>

    <div class="bg-white border border-outline-variant rounded-xl overflow-hidden shadow-sm">
        @if($documents->count() > 0)
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse zebra-table">
                    <thead>
                        <tr class="bg-surface-container-low border-b border-outline-variant">
                            <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Business</th>
                            <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Document Type</th>
                            <th class="px-md py-md text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">Uploaded</th>
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
                                <td class="px-md py-md text-on-surface-variant">{{ $doc->created_at->format('M d, Y') }}</td>
                                <td class="px-md py-md text-right">
                                    <a href="{{ route('admin.documents.review', $doc->id) }}" class="px-sm py-sm bg-primary-container text-on-primary rounded-lg text-[11px] font-bold hover:bg-primary transition-colors inline-flex items-center gap-xs">
                                        <span class="material-symbols-outlined text-[16px]">rate_review</span>
                                        Review
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
        @else
            <div class="p-lg text-center">
                <span class="material-symbols-outlined text-[48px] text-on-surface-variant mb-sm">verified</span>
                <p class="text-on-surface-variant text-sm">No pending documents</p>
            </div>
        @endif
    </div>
@endsection
