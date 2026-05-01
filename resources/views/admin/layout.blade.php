<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Panel') - MedFootApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#c74454',
                        'primary-dark': '#8b2e3a',
                        'primary-bg': '#fce4e8',
                        'primary-text': '#c74454',
                    }
                }
            }
        }
    </script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
        .sidebar { position: fixed; top: 0; left: 0; width: 260px; height: 100vh; background: linear-gradient(180deg, #c74454 0%, #8b2e3a 100%); color: white; overflow-y: auto; z-index: 50; }
        .sidebar a { display: flex; align-items: center; padding: 12px 24px; color: white; text-decoration: none; font-size: 14px; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar a:hover { background: rgba(255,255,255,0.1); border-left-color: white; }
        .sidebar a.active { background: rgba(255,255,255,0.15); border-left-color: white; }
        .sidebar svg { flex-shrink: 0; }
        .main { margin-left: 260px; padding: 32px; min-height: 100vh; background: #f8fafc; }
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; display: flex; align-items: center; }
        .alert-success { background: #dcfce7; border: 1px solid #86efac; color: #166534; }
        .alert-error { background: #fee2e2; border: 1px solid #fca5a5; color: #991b1b; }
        .badge { margin-left: auto; background: #ef4444; color: white; font-size: 11px; padding: 2px 8px; border-radius: 999px; font-weight: 600; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.3); border-radius: 3px; }
    </style>
</head>
<body>
    <div class="min-h-screen">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div style="padding: 24px 24px 16px; border-bottom: 1px solid rgba(255,255,255,0.2);">
                <div style="background: white; padding: 10px; border-radius: 8px; display: inline-block; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    <img src="{{ asset('logo.png') }}" alt="MedFootApp" style="height: 36px; display: block;" onerror="this.parentElement.style.background='#ffffff';">
                </div>
                <p style="font-size: 12px; color: rgba(255,255,255,0.8); margin: 0; letter-spacing: 0.5px; text-transform: uppercase;">Admin Panel</p>
            </div>

            <nav style="margin-top: 16px; padding: 0 12px;">
                <a href="{{ route('admin.dashboard') }}" class="{{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-4 0h4"/>
                    </svg>
                    Dashboard
                </a>

                <a href="{{ route('admin.users.index') }}" class="{{ request()->routeIs('admin.users.*') ? 'active' : '' }}">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                    </svg>
                    Users
                </a>

                <a href="{{ route('admin.products.index') }}" class="{{ request()->routeIs('admin.products.*') ? 'active' : '' }}">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                    </svg>
                    Products
                </a>

                <a href="{{ route('admin.orders.index') }}" class="{{ request()->routeIs('admin.orders.*') ? 'active' : '' }}">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                    </svg>
                    Orders
                </a>

                <a href="{{ route('admin.documents.pending') }}" class="{{ request()->routeIs('admin.documents.*') ? 'active' : '' }}">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                    Documents
                    @if(isset($pendingDocsCount) && $pendingDocsCount > 0)
                        <span class="badge">{{ $pendingDocsCount }}</span>
                    @endif
                </a>

                <a href="{{ route('admin.settings') }}" class="{{ request()->routeIs('admin.settings*') ? 'active' : '' }}">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                    Settings
                </a>

                <div style="border-top: 1px solid rgba(255,255,255,0.2); margin-top: 16px; padding-top: 16px;">
                    <form method="POST" action="{{ route('logout') }}" style="padding: 0 12px;">
                        @csrf
                        <button type="submit" style="display: flex; align-items: center; background: none; border: none; color: white; cursor: pointer; width: 100%; font-size: 14px; padding: 12px 12px; border-radius: 6px; transition: background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.1)'" onmouseout="this.style.background='none'">
                            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
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
                    <svg class="w-5 h-5 mr-2 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    {{ session('success') }}
                </div>
            @endif

            @if(session('error'))
                <div class="alert alert-error">
                    <svg class="w-5 h-5 mr-2 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    {{ session('error') }}
                </div>
            @endif

            @yield('content')
        </main>
    </div>
</body>
</html>
