<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\VerificationDocument;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => ['required', 'confirmed', Password::defaults()],
            'phone' => 'nullable|string|max:20',
            'role' => 'required|in:customer,business',
            'business_name' => 'required_if:role,business|nullable|string|max:255',
            'business_type' => 'required_if:role,business|nullable|in:pharmacy,hospital,clinic,other',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'phone' => $validated['phone'] ?? null,
            'role' => $validated['role'],
            'is_verified' => false,
            'business_name' => $validated['business_name'] ?? null,
            'business_type' => $validated['business_type'] ?? null,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Registration successful',
            'user' => $this->formatUserResponse($user),
            'token' => $token,
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (!$user || !Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'message' => 'Invalid credentials',
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'user' => $this->formatUserResponse($user),
            'token' => $token,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out successfully',
        ]);
    }

    public function me(Request $request)
    {
        return response()->json([
            'user' => $this->formatUserResponse($request->user()),
        ]);
    }

    public function verificationStatus(Request $request)
    {
        $user = $request->user();

        $documents = $user->documents()->get()->map(function ($doc) {
            return [
                'id' => $doc->id,
                'document_type' => $doc->document_type,
                'status' => $doc->status,
                'review_notes' => $doc->review_notes,
                'reviewed_at' => $doc->reviewed_at,
            ];
        });

        $hasBothApproved = $user->documents()
            ->where('status', VerificationDocument::STATUS_APPROVED)
            ->whereIn('document_type', [VerificationDocument::TYPE_TMDA, VerificationDocument::TYPE_TRA])
            ->count() === 2;

        if ($hasBothApproved && !$user->is_verified) {
            $user->update(['is_verified' => true]);
        }

        return response()->json([
            'is_verified' => $user->is_verified,
            'documents' => $documents,
        ]);
    }

    private function formatUserResponse(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'phone' => $user->phone,
            'role' => $user->role,
            'is_verified' => $user->is_verified,
            'business_name' => $user->business_name,
            'business_type' => $user->business_type,
        ];
    }
}
