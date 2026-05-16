<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - MedFoot</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#93000b",
                        "primary-container": "#b91c1c",
                        background: "#f9f9ff",
                        "on-surface": "#111c2d",
                        "on-surface-variant": "#5b403d",
                        "outline-variant": "#e4beb9",
                        "surface-container-low": "#f0f3ff",
                        "surface-container-lowest": "#ffffff",
                    },
                    fontFamily: {
                        sans: ["Manrope", "sans-serif"],
                    },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Manrope', sans-serif; background-color: #f9f9ff; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md">
        <div class="text-center mb-lg">
            <div class="w-16 h-16 rounded-xl bg-primary-container flex items-center justify-center mx-auto mb-md shadow-sm">
                <span class="material-symbols-outlined text-white text-[32px]">local_hospital</span>
            </div>
            <h1 class="text-[28px] font-bold text-primary tracking-tight">MedFoot Admin</h1>
            <p class="text-sm text-on-surface-variant">Clinical Oversight Portal</p>
        </div>

        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-sm">
            @if($errors->any())
                <div class="mb-md p-sm bg-red-50 border border-red-200 rounded-lg flex items-center gap-sm">
                    <span class="material-symbols-outlined text-red-600 text-[18px]">error</span>
                    <div class="text-sm text-red-700">
                        @foreach($errors->all() as $error)
                            <p>{{ $error }}</p>
                        @endforeach
                    </div>
                </div>
            @endif

            <form method="POST" action="{{ route('login') }}">
                @csrf

                <div class="mb-md">
                    <label class="block text-[11px] font-bold text-on-surface-variant mb-1 uppercase tracking-wider">Email</label>
                    <input type="email" name="email" required
                           class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                           placeholder="admin@medfoot.com">
                </div>

                <div class="mb-lg">
                    <label class="block text-[11px] font-bold text-on-surface-variant mb-1 uppercase tracking-wider">Password</label>
                    <input type="password" name="password" required
                           class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                           placeholder="Enter password">
                </div>

                <button type="submit"
                        class="w-full bg-primary-container text-white py-sm rounded-lg text-[11px] font-bold uppercase tracking-wider hover:bg-primary transition-colors shadow-sm">
                    Sign In
                </button>
            </form>

            <div class="mt-md text-center">
                <span class="text-[10px] text-on-surface-variant font-medium">v2.4.0 · MedFoot Clinical Systems</span>
            </div>
        </div>
    </div>
</body>
</html>
