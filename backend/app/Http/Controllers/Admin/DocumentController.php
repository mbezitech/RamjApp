<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\VerificationDocument;
use Illuminate\Http\Request;

class DocumentController extends Controller
{
    public function pending()
    {
        $documents = VerificationDocument::with('user')
            ->where('status', 'pending')
            ->latest()
            ->paginate(20);

        return view('admin.documents.pending', compact('documents'));
    }

    public function review(VerificationDocument $document)
    {
        $document->load('user');
        return view('admin.documents.review', compact('document'));
    }

    public function approve(VerificationDocument $document)
    {
        $document->update([
            'status' => 'approved',
            'reviewed_by' => request()->user()->id,
            'reviewed_at' => now(),
        ]);

        $user = $document->user;

        $hasBothApproved = $user->documents()
            ->where('status', 'approved')
            ->whereIn('document_type', ['tmda', 'tra'])
            ->count() === 2;

        if ($hasBothApproved) {
            $user->update(['is_verified' => true]);
        }

        return redirect()->route('admin.documents.pending')
            ->with('success', 'Document approved successfully.');
    }

    public function reject(Request $request, VerificationDocument $document)
    {
        $request->validate([
            'review_notes' => 'required|string',
        ]);

        $document->update([
            'status' => 'rejected',
            'review_notes' => $request->review_notes,
            'reviewed_by' => $request->user()->id,
            'reviewed_at' => now(),
        ]);

        return redirect()->route('admin.documents.pending')
            ->with('success', 'Document rejected.');
    }

    public function all(Request $request)
    {
        $query = VerificationDocument::with('user');

        if ($request->has('status') && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        $documents = $query->latest()->paginate(20);

        return view('admin.documents.all', compact('documents'));
    }
}
