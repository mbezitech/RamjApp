@extends('admin.layout')

@section('title', 'Document Review')

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.documents.pending') }}" class="text-blue-600 hover:underline">← Back to Pending</a>
    </div>

    <div class="max-w-2xl">
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-xl font-bold mb-4">{{ strtoupper($document->document_type) }} Certificate</h2>

            <div class="space-y-3 mb-6">
                <div class="flex justify-between">
                    <span class="text-gray-600">Business</span>
                    <span class="font-medium">{{ $document->user->business_name ?? $document->user->name }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Uploaded</span>
                    <span class="font-medium">{{ $document->created_at->format('M d, Y - h:i A') }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Status</span>
                    <span class="px-2 py-1 text-xs rounded-full
                        @if($document->status == 'approved') bg-green-100 text-green-800
                        @elseif($document->status == 'rejected') bg-red-100 text-red-800
                        @else bg-yellow-100 text-yellow-800 @endif">
                        {{ ucfirst($document->status) }}
                    </span>
                </div>
            </div>

            <div class="bg-gray-50 p-4 rounded mb-6">
                <p class="text-sm text-gray-600 mb-2">Document Preview:</p>
                <a href="{{ asset('storage/' . $document->file_path) }}"
                   target="_blank"
                   class="text-blue-600 hover:underline">
                    View Document →
                </a>
            </div>

            @if($document->status == 'pending')
                <div class="flex gap-4">
                    <form method="POST" action="{{ route('admin.documents.approve', $document->id) }}" class="flex-1">
                        @csrf
                        <button type="submit"
                                class="w-full bg-green-600 text-white py-2 rounded hover:bg-green-700"
                                onclick="return confirm('Approve this document?')">
                            Approve
                        </button>
                    </form>

                    <form method="POST" action="{{ route('admin.documents.reject', $document->id) }}" class="flex-1">
                        @csrf
                        <div class="mb-2">
                            <textarea name="review_notes" placeholder="Reason for rejection..."
                                      class="w-full border border-gray-300 rounded px-3 py-2 text-sm" required></textarea>
                        </div>
                        <button type="submit"
                                class="w-full bg-red-600 text-white py-2 rounded hover:bg-red-700"
                                onclick="return confirm('Reject this document?')">
                            Reject
                        </button>
                    </form>
                </div>
            @endif
        </div>
    </div>
@endsection
