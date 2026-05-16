@extends('admin.layout')

@section('title', 'Document Review')

@section('content')
    <div class="mb-md">
        <a href="{{ URL::previous() }}" class="text-primary text-[11px] font-bold hover:underline inline-flex items-center gap-xs">
            <span class="material-symbols-outlined text-[16px]">arrow_back</span>
            Back
        </a>
    </div>

    <div class="max-w-2xl">
        <div class="bg-white border border-outline-variant rounded-xl p-md">
            <h2 class="text-h3 text-on-surface font-semibold mb-md">{{ strtoupper($document->document_type) }} Certificate</h2>

            <div class="space-y-3 mb-md">
                <div class="flex justify-between">
                    <span class="text-sm text-on-surface-variant">Business</span>
                    <span class="text-sm font-semibold text-on-surface">{{ $document->user->business_name ?? $document->user->name }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-sm text-on-surface-variant">Uploaded</span>
                    <span class="text-sm font-medium text-on-surface">{{ $document->created_at->format('M d, Y - h:i A') }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-sm text-on-surface-variant">Status</span>
                    <span class="px-2 py-0.5 text-[10px] font-bold rounded
                        @if($document->status == 'approved') bg-green-100 text-green-700
                        @elseif($document->status == 'rejected') bg-red-100 text-red-700
                        @else bg-yellow-100 text-yellow-700 @endif">
                        {{ ucfirst($document->status) }}
                    </span>
                </div>
            </div>

            <div class="bg-surface-container-low p-md rounded-lg mb-md">
                <p class="text-sm text-on-surface-variant mb-2">Document Preview:</p>
                <a href="{{ asset('storage/' . $document->file_path) }}"
                   class="text-primary text-sm font-bold hover:underline inline-flex items-center gap-xs">
                    <span class="material-symbols-outlined text-[16px]">visibility</span>
                    View Document
                </a>
            </div>

            @if($document->status == 'pending')
                <div class="flex gap-md">
                    <form method="POST" action="{{ route('admin.documents.approve', $document->id) }}" class="flex-1">
                        @csrf
                        <button type="submit"
                                class="w-full bg-green-600 text-white py-sm rounded-lg text-[11px] font-bold hover:bg-green-700 transition-colors"
                                onclick="return confirm('Approve this document?')">
                            <span class="material-symbols-outlined text-[16px] align-middle mr-1">check</span>
                            Approve
                        </button>
                    </form>

                    <form method="POST" action="{{ route('admin.documents.reject', $document->id) }}" class="flex-1">
                        @csrf
                        <div class="mb-2">
                            <textarea name="review_notes" placeholder="Reason for rejection..."
                                      class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm outline-none focus:ring-2 focus:ring-primary" required></textarea>
                        </div>
                        <button type="submit"
                                class="w-full bg-red-600 text-white py-sm rounded-lg text-[11px] font-bold hover:bg-red-700 transition-colors"
                                onclick="return confirm('Reject this document?')">
                            <span class="material-symbols-outlined text-[16px] align-middle mr-1">close</span>
                            Reject
                        </button>
                    </form>
                </div>
            @endif
        </div>
    </div>
@endsection
