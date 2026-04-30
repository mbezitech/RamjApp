<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Panel') - MedFootApp</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f3f4f6; }
        .sidebar { position: fixed; top: 0; left: 0; width: 256px; height: 100vh; background: #c74454; color: white; }
        .sidebar a { display: flex; align-items: center; padding: 12px 24px; color: white; text-decoration: none; font-size: 14px; }
        .sidebar a:hover { background: #8b2e3a; }
        .sidebar svg { width: 20px; height: 20px; margin-right: 12px; stroke: white; fill: none; flex-shrink: 0; }
        .main { margin-left: 256px; padding: 32px; }
        .alert { padding: 12px 16px; border-radius: 6px; margin-bottom: 16px; }
        .alert-success { background: #dcfce7; border: 1px solid #4ade80; color: #15803d; }
        .alert-error { background: #fee2e2; border: 1px solid #f87171; color: #b91c1c; }
        .badge { margin-left: auto; background: #ef4444; color: white; font-size: 10px; padding: 2px 8px; border-radius: 999px; }
    </style>
</head>
<body>
    <div>
        <!-- Sidebar -->
        <aside class="sidebar">
            <div style="padding: 24px; border-bottom: 1px solid #8b2e3a;">
                <div style="background: white; padding: 8px; border-radius: 4px; display: inline-block; margin-bottom: 8px;">
                    <img src="{{ asset('logo.png') }}" alt="MedFootApp" style="height: 40px; display: block;" onerror="this.parentElement.style.background='#ffffff'; this.alt='MedFootApp';">
                </div>
                <p style="font-size: 13px; color: white; margin: 8px 0 0 0;">Admin Panel</p>
            </div>

            <nav style="margin-top: 24px;">
                <a href="{{ route('admin.dashboard') }}">
                    <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-4 0h4"/>
                    </svg>
                    Dashboard
                </a>

                <a href="{{ route('admin.users.index') }}">
                    <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                    </svg>
                    Users
                </a>

                <a href="{{ route('admin.products.index') }}">
                    <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                    </svg>
                    Products
                </a>

                <a href="{{ route('admin.orders.index') }}">
                    <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                    </svg>
                    Orders
                </a>

                <a href="{{ route('admin.documents.pending') }}">
                    <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                    Documents
                    @if(isset($pendingDocsCount) && $pendingDocsCount > 0)
                        <span class="badge">{{ $pendingDocsCount }}</span>
                    @endif
                </a>

                <div style="border-top: 1px solid #8b2e3a; margin-top: 24px; padding-top: 24px;">
                    <a href="{{ route('admin.dashboard') }}">
                        <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-4 0h4"/>
                        </svg>
                        Back to Site
                    </a>

                    <form method="POST" action="{{ route('logout') }}" style="padding: 12px 24px;">
                        @csrf
                        <button type="submit" style="display: flex; align-items: center; background: none; border: none; color: white; cursor: pointer; width: 100%; font-size: 14px;">
                            <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 20px; height: 20px; margin-right: 12px; stroke: white; fill: none;">
                                <path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                            </svg>
                            Logout
                        </button>
                    </form>
                </div>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main">
            @if(session('success'))
                <div class="alert alert-success">
                    {{ session('success') }}
                </div>
            @endif

            @if(session('error'))
                <div class="alert alert-error">
                    {{ session('error') }}
                </div>
            @endif

            @yield('content')
        </main>
    </div>
</body>
</html>
