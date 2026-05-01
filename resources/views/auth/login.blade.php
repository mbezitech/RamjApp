<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - MedFootApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#c74454',
                        'primary-dark': '#8b2e3a',
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full">
        <div class="text-center mb-8">
            <img src="{{ asset('logo.png') }}" alt="MedFootApp" class="h-16 mx-auto mb-4">
            <p class="text-gray-600">Admin Panel Login</p>
        </div>

        <div class="bg-white rounded-lg shadow p-8">
            @if($errors->any())
                <div class="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                    <ul>
                        @foreach($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <form method="POST" action="{{ route('login') }}">
                @csrf

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                    <input type="email" name="email" required
                           class="w-full border border-gray-300 rounded px-3 py-2"
                           placeholder="admin@medfootapp.com">
                </div>

                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                    <input type="password" name="password" required
                           class="w-full border border-gray-300 rounded px-3 py-2"
                           placeholder="Enter password">
                </div>

                <button type="submit"
                        class="w-full bg-primary text-white py-2 rounded hover:bg-primary-dark">
                    Login
                </button>
            </form>
        </div>
    </div>
</body>
</html>
