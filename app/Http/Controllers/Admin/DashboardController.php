<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Product;
use App\Models\Order;
use App\Models\VerificationDocument;

class DashboardController extends Controller
{
    public function index()
    {
        $stats = [
            'total_users' => User::count(),
            'verified_businesses' => User::where('role', 'business')->where('is_verified', true)->count(),
            'pending_documents' => VerificationDocument::where('status', 'pending')->count(),
            'total_products' => Product::count(),
            'medicines' => Product::where('category', 'medicine')->count(),
            'equipment' => Product::where('category', 'equipment')->count(),
            'total_orders' => Order::count(),
            'pending_orders' => Order::where('status', 'pending')->count(),
        ];

        $recentOrders = Order::with('user')->latest()->take(5)->get();
        $pendingDocuments = VerificationDocument::with('user')
            ->where('status', 'pending')
            ->latest()
            ->take(5)
            ->get();

        return view('admin.dashboard', compact('stats', 'recentOrders', 'pendingDocuments'));
    }
}
