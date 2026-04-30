@extends('admin.layout')

@section('title', 'Pending Documents')

@section('content')
    <div class="mb-6 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Pending Verifications</h1>
            <p class="text-gray-600">Review business verification documents</p>
        </div>
         <a href="{{ route('admin.documents.all') }}"
            class="bg-primary text-white px-4 py-2 rounded hover:bg-primary-dark">
            View All Documents
        </a>
    </div>

    <!-- Pending Documents -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
        @if($documents->count() > 0)
            <table class="min-w-full">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Business</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Document Type</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Uploaded</th>
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
                            <td class="px-6 py-4 text-sm text-gray-600">
                                {{ $doc->created_at->format('M d, Y') }}
                            </td>
                            <td class="px-6 py-4">
                                <a href="{{ route('admin.documents.review', $doc->id) }}"
                                   class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700">
                                    Review
                                </a>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
            <div class="px-6 py-4 border-t border-gray-200">
                {{ $documents->links() }}
            </div>
        @else
            <div class="p-8 text-center">
                <p class="text-gray-500">No pending documents</p>
            </div>
        @endif
    </div>
@endsection
