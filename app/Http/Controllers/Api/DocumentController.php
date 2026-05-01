<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\VerificationDocument;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class DocumentController extends Controller
{
    public function upload(Request $request)
    {
        $validated = $request->validate([
            'document_type' => 'required|in:tmda,tra',
            'document' => 'required|file|mimes:jpg,jpeg,png,pdf|max:5120',
        ]);

        $user = $request->user();

        if ($user->role !== 'business') {
            return response()->json([
                'message' => 'Only business accounts can upload verification documents.',
            ], 403);
        }

        $existingDoc = $user->documents()
            ->where('document_type', $validated['document_type'])
            ->first();

        if ($existingDoc) {
            if ($existingDoc->status === VerificationDocument::STATUS_APPROVED) {
                return response()->json([
                    'message' => 'This document is already approved.',
                ], 400);
            }

            if ($existingDoc->file_path && Storage::disk('public')->exists($existingDoc->file_path)) {
                Storage::disk('public')->delete($existingDoc->file_path);
            }
        }

        $path = $request->file('document')->store('verification_documents');

        $document = $user->documents()->updateOrCreate(
            ['document_type' => $validated['document_type']],
            [
                'file_path' => $path,
                'status' => VerificationDocument::STATUS_PENDING,
                'reviewed_by' => null,
                'review_notes' => null,
                'reviewed_at' => null,
            ]
        );

        return response()->json([
            'message' => 'Document uploaded successfully. Pending review.',
            'document' => [
                'id' => $document->id,
                'document_type' => $document->document_type,
                'status' => $document->status,
            ],
        ], 201);
    }

    public function index(Request $request)
    {
        $documents = $request->user()->documents()->latest()->get();

        return response()->json([
            'documents' => $documents->map(function ($doc) {
                return [
                    'id' => $doc->id,
                    'document_type' => $doc->document_type,
                    'status' => $doc->status,
                    'review_notes' => $doc->review_notes,
                    'reviewed_at' => $doc->reviewed_at,
                    'created_at' => $doc->created_at,
                ];
            }),
        ]);
    }

    public function review(Request $request, VerificationDocument $document)
    {
        $validated = $request->validate([
            'status' => 'required|in:approved,rejected',
            'review_notes' => 'nullable|string',
        ]);

        $document->update([
            'status' => $validated['status'],
            'review_notes' => $validated['review_notes'] ?? null,
            'reviewed_by' => $request->user()->id,
            'reviewed_at' => now(),
        ]);

        $user = $document->user;

        $hasBothApproved = $user->documents()
            ->where('status', VerificationDocument::STATUS_APPROVED)
            ->whereIn('document_type', [VerificationDocument::TYPE_TMDA, VerificationDocument::TYPE_TRA])
            ->count() === 2;

        if ($hasBothApproved) {
            $user->update([
                'is_verified' => true,
                'role' => 'business',
            ]);
        }

        return response()->json([
            'message' => 'Document review submitted successfully',
            'document' => [
                'id' => $document->id,
                'status' => $document->status,
                'review_notes' => $document->review_notes,
            ],
        ]);
    }

    public function pending(Request $request)
    {
        $documents = VerificationDocument::where('status', VerificationDocument::STATUS_PENDING)
            ->with('user')
            ->latest()
            ->paginate(20);

        return response()->json([
            'documents' => $documents->getCollection()->map(function ($doc) {
                return [
                    'id' => $doc->id,
                    'document_type' => $doc->document_type,
                    'user' => [
                        'id' => $doc->user->id,
                        'name' => $doc->user->name,
                        'email' => $doc->user->email,
                        'business_name' => $doc->user->business_name,
                    ],
                    'file_path' => $doc->file_path,
                    'created_at' => $doc->created_at,
                ];
            }),
            'current_page' => $documents->currentPage(),
            'last_page' => $documents->lastPage(),
            'total' => $documents->total(),
        ]);
    }
}
