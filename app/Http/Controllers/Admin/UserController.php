<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AppSetting;
use App\Models\User;
use App\Models\VerificationDocument;
use App\Services\MailService;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $query = User::query();

        if ($request->has('role') && $request->role !== 'all') {
            $query->where('role', $request->role);
        }

        if ($request->has('verified') && $request->verified !== 'all') {
            $query->where('is_verified', $request->verified === 'true');
        }

        $users = $query->latest()->paginate(20);

        return view('admin.users.index', compact('users'));
    }

    public function show(User $user)
    {
        $documents = $user->documents()->latest()->get();
        $orders = $user->orders()->latest()->take(10)->get();

        return view('admin.users.show', compact('user', 'documents', 'orders'));
    }

    public function verify(User $user)
    {
        $user->update(['is_verified' => true]);

        $notifyApproval = AppSetting::get('notify_approval_enabled', 'true') === 'true';
        if ($notifyApproval) {
            try {
                MailService::sendTo($user->email, 'Your Account Has Been Approved!', 'emails.account-approved', [
                    'userName' => $user->name,
                    'businessName' => $user->business_name,
                    'businessType' => $user->business_type,
                ]);
            } catch (\Exception $e) {
                \Log::error('Approval email failed: ' . $e->getMessage());
            }
        }

        return redirect()->back()->with('success', 'User verified successfully.');
    }

    public function unverify(User $user)
    {
        $user->update(['is_verified' => false]);

        return redirect()->back()->with('success', 'User verification removed.');
    }

    public function activate(User $user)
    {
        $user->update(['is_active' => true]);

        return redirect()->back()->with('success', 'User account activated successfully.');
    }

    public function deactivate(User $user)
    {
        if ($user->role === 'admin') {
            return redirect()->back()->with('error', 'Cannot deactivate admin users.');
        }

        $user->update(['is_active' => false]);

        return redirect()->back()->with('success', 'User account deactivated successfully.');
    }

    public function updateRole(Request $request, User $user)
    {
        if ($user->role === 'admin') {
            return redirect()->back()->with('error', 'Cannot change admin user role.');
        }

        $request->validate([
            'role' => 'required|in:customer,business,admin',
        ]);

        $user->update(['role' => $request->role]);

        return redirect()->back()->with('success', 'User role updated successfully.');
    }

    public function destroy(User $user)
    {
        if ($user->role === 'admin') {
            return redirect()->back()->with('error', 'Cannot delete admin users.');
        }

        $user->delete();

        return redirect()->route('admin.users.index')->with('success', 'User deleted successfully.');
    }
}
