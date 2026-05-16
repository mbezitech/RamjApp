<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Panel') - MedFoot</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface-container-lowest": "#ffffff",
                        "on-primary-fixed-variant": "#93000b",
                        "background": "#f9f9ff",
                        "tertiary-container": "#5c5f61",
                        "on-primary": "#ffffff",
                        "surface-bright": "#f9f9ff",
                        "on-primary-fixed": "#410002",
                        "outline-variant": "#e4beb9",
                        "on-surface-variant": "#5b403d",
                        "secondary": "#515f74",
                        "on-tertiary-fixed-variant": "#444749",
                        "surface": "#f9f9ff",
                        "on-surface": "#111c2d",
                        "on-secondary-fixed": "#0d1c2e",
                        "on-tertiary": "#ffffff",
                        "secondary-fixed-dim": "#b9c7df",
                        "surface-container-highest": "#d8e3fb",
                        "primary-fixed-dim": "#ffb4ab",
                        "primary-container": "#b91c1c",
                        "on-tertiary-container": "#d7d9db",
                        "surface-container-high": "#dee8ff",
                        "inverse-primary": "#ffb4ab",
                        "primary-fixed": "#ffdad6",
                        "primary": "#93000b",
                        "surface-container-low": "#f0f3ff",
                        "on-secondary-container": "#57657a",
                        "on-background": "#111c2d",
                        "on-secondary": "#ffffff",
                        "on-error-container": "#93000a",
                        "error-container": "#ffdad6",
                        "on-secondary-fixed-variant": "#3a485b",
                        "error": "#ba1a1a",
                        "secondary-container": "#d5e3fc",
                        "tertiary-fixed-dim": "#c4c7c9",
                        "secondary-fixed": "#d5e3fc",
                        "surface-variant": "#d8e3fb",
                        "surface-tint": "#b91c1c",
                        "on-error": "#ffffff",
                        "surface-dim": "#cfdaf2",
                        "surface-container": "#e7eeff",
                        "inverse-on-surface": "#ecf1ff",
                        "outline": "#8f6f6c",
                        "tertiary": "#444749",
                        "tertiary-fixed": "#e0e3e5",
                        "on-primary-container": "#ffcdc7",
                        "inverse-surface": "#263143",
                        "on-tertiary-fixed": "#191c1e"
                    },
                    borderRadius: {
                        DEFAULT: "0.25rem",
                        lg: "0.5rem",
                        xl: "0.75rem",
                        full: "9999px"
                    },
                    spacing: {
                        xs: "8px",
                        gutter: "24px",
                        base: "4px",
                        sm: "16px",
                        md: "24px",
                        lg: "40px",
                        xl: "64px",
                        margin: "32px"
                    },
                    fontFamily: {
                        sans: ["Manrope", "sans-serif"],
                    },
                    fontSize: {
                        h1: ["40px", { lineHeight: "1.2", letterSpacing: "-0.02em", fontWeight: "700" }],
                        h2: ["32px", { lineHeight: "1.2", letterSpacing: "-0.02em", fontWeight: "700" }],
                        h3: ["24px", { lineHeight: "1.3", letterSpacing: "-0.01em", fontWeight: "600" }],
                        "body-lg": ["18px", { lineHeight: "1.6", letterSpacing: "0", fontWeight: "400" }],
                        "body-md": ["16px", { lineHeight: "1.6", letterSpacing: "0", fontWeight: "400" }],
                        "body-sm": ["14px", { lineHeight: "1.5", letterSpacing: "0", fontWeight: "400" }],
                        "label-bold": ["12px", { lineHeight: "1.2", letterSpacing: "0.05em", fontWeight: "700" }],
                        "label-md": ["12px", { lineHeight: "1.2", letterSpacing: "0.01em", fontWeight: "500" }],
                    }
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Manrope', sans-serif; background-color: #f9f9ff; color: #111c2d; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .sidebar-active-gradient {
            background: linear-gradient(90deg, rgba(147, 0, 11, 0.08) 0%, rgba(147, 0, 11, 0) 100%);
        }
        .zebra-table tbody tr:nth-child(even) { background-color: #f8fafc; }
        .clinical-shadow { box-shadow: 0px 10px 25px -5px rgba(30, 41, 59, 0.05); }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(147, 0, 11, 0.2); border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(147, 0, 11, 0.4); }
    </style>
</head>
<body>
    <!-- TopAppBar -->
    <header class="fixed top-0 left-0 w-full z-50 flex justify-between items-center px-gutter h-16 bg-surface-container-lowest border-b border-outline-variant">
        <div class="flex items-center gap-sm">
            <h1 class="text-[22px] font-bold text-primary tracking-tight">MedFoot Admin</h1>
        </div>
        <div class="flex items-center gap-sm">
            <div class="hidden md:flex items-center gap-md mr-lg">
                <span class="text-[11px] font-bold text-primary tracking-wider uppercase">Admin</span>
                <span class="text-[11px] font-bold text-on-surface-variant tracking-wider uppercase px-2 py-1 rounded hover:bg-surface-container-low transition-colors cursor-pointer">Logs</span>
            </div>
            <div class="w-9 h-9 rounded-full bg-primary-fixed flex items-center justify-center text-primary font-bold text-sm">A</div>
        </div>
    </header>

    <!-- Sidebar -->
    <aside class="fixed left-0 top-0 h-screen flex flex-col p-sm z-40 bg-surface-container-lowest border-r border-outline-variant w-72 pt-20">
        <div class="flex items-center gap-sm px-sm py-md mb-md border-b border-outline-variant/30">
            <div class="w-10 h-10 rounded-lg bg-primary-container flex items-center justify-center shrink-0">
                <span class="material-symbols-outlined text-on-primary text-[22px]">local_hospital</span>
            </div>
            <div>
                <h3 class="text-[16px] font-semibold text-primary leading-none">MedFoot Admin</h3>
                <p class="text-[11px] text-on-surface-variant mt-0.5 font-medium">Clinical Oversight</p>
            </div>
        </div>
        <nav class="flex flex-col gap-base overflow-y-auto">
            <a href="{{ route('admin.dashboard') }}"
               class="flex items-center gap-sm px-sm py-sm {{ request()->routeIs('admin.dashboard') ? 'text-primary bg-primary-fixed font-bold rounded-lg' : 'text-on-surface-variant hover:bg-surface-container-low rounded-lg transition-all' }}">
                <span class="material-symbols-outlined text-[20px]">dashboard</span>
                <span class="text-[11px] font-bold tracking-wider uppercase">Dashboard</span>
            </a>
            <a href="{{ route('admin.users.index') }}"
               class="flex items-center gap-sm px-sm py-sm {{ request()->routeIs('admin.users.*') ? 'text-primary bg-primary-fixed font-bold rounded-lg' : 'text-on-surface-variant hover:bg-surface-container-low rounded-lg transition-all' }}">
                <span class="material-symbols-outlined text-[20px]">group</span>
                <span class="text-[11px] font-bold tracking-wider uppercase">Users</span>
            </a>
            <a href="{{ route('admin.products.index') }}"
               class="flex items-center gap-sm px-sm py-sm {{ request()->routeIs('admin.products.*') ? 'text-primary bg-primary-fixed font-bold rounded-lg' : 'text-on-surface-variant hover:bg-surface-container-low rounded-lg transition-all' }}">
                <span class="material-symbols-outlined text-[20px]">inventory_2</span>
                <span class="text-[11px] font-bold tracking-wider uppercase">Inventory</span>
            </a>
            <a href="{{ route('admin.orders.index') }}"
               class="flex items-center gap-sm px-sm py-sm {{ request()->routeIs('admin.orders.*') ? 'text-primary bg-primary-fixed font-bold rounded-lg' : 'text-on-surface-variant hover:bg-surface-container-low rounded-lg transition-all' }}">
                <span class="material-symbols-outlined text-[20px]">shopping_cart</span>
                <span class="text-[11px] font-bold tracking-wider uppercase">Orders</span>
            </a>
            <a href="{{ route('admin.facilities.index') }}"
               class="flex items-center gap-sm px-sm py-sm {{ request()->routeIs('admin.facilities.*') ? 'text-primary bg-primary-fixed font-bold rounded-lg' : 'text-on-surface-variant hover:bg-surface-container-low rounded-lg transition-all' }}">
                <span class="material-symbols-outlined text-[20px]">local_hospital</span>
                <span class="text-[11px] font-bold tracking-wider uppercase">Facilities</span>
            </a>
            <a href="{{ route('admin.documents.pending') }}"
               class="flex items-center gap-sm px-sm py-sm {{ request()->routeIs('admin.documents.*') ? 'text-primary bg-primary-fixed font-bold rounded-lg' : 'text-on-surface-variant hover:bg-surface-container-low rounded-lg transition-all' }}">
                <span class="material-symbols-outlined text-[20px]">description</span>
                <span class="text-[11px] font-bold tracking-wider uppercase">Documents</span>
                @if(isset($pendingDocsCount) && $pendingDocsCount > 0)
                    <span class="ml-auto w-5 h-5 rounded-full bg-primary text-on-primary text-[10px] font-bold flex items-center justify-center">{{ $pendingDocsCount > 9 ? '9+' : $pendingDocsCount }}</span>
                @endif
            </a>
            <a href="{{ route('admin.settings') }}"
               class="flex items-center gap-sm px-sm py-sm {{ request()->routeIs('admin.settings*') ? 'text-primary bg-primary-fixed font-bold rounded-lg' : 'text-on-surface-variant hover:bg-surface-container-low rounded-lg transition-all' }}">
                <span class="material-symbols-outlined text-[20px]">settings</span>
                <span class="text-[11px] font-bold tracking-wider uppercase">Settings</span>
            </a>
        </nav>
        <div class="mt-auto px-sm py-sm border-t border-outline-variant/30">
            <div class="flex items-center justify-between mb-1">
                <span class="text-[10px] text-on-surface-variant font-medium">System Status</span>
                <span class="w-2 h-2 rounded-full bg-green-500"></span>
            </div>
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-bold text-on-surface">v2.4.0</span>
                <form method="POST" action="{{ route('logout') }}" class="inline">
                    @csrf
                    <button type="submit" class="text-[10px] text-on-surface-variant hover:text-primary transition-colors font-medium">Logout</button>
                </form>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="ml-72 pt-16 min-h-screen">
        <div class="max-w-[1280px] mx-auto p-gutter">
            @if(session('success'))
                <div class="mb-md p-sm bg-green-50 border border-green-200 rounded-lg flex items-center gap-sm">
                    <span class="material-symbols-outlined text-green-600 text-[20px]">check_circle</span>
                    <span class="text-sm text-green-800 font-medium">{{ session('success') }}</span>
                </div>
            @endif
            @if(session('error'))
                <div class="mb-md p-sm bg-red-50 border border-red-200 rounded-lg flex items-center gap-sm">
                    <span class="material-symbols-outlined text-red-600 text-[20px]">error</span>
                    <span class="text-sm text-red-800 font-medium">{{ session('error') }}</span>
                </div>
            @endif
            @yield('content')
        </div>
    </main>
</body>
</html>
