@extends('admin.layout')

@section('title', 'Create Product')

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.products.index') }}" class="text-primary hover:underline">← Back to Products</a>
    </div>

    <div class="max-w-2xl">
        <div class="bg-white rounded-lg shadow p-6">
            <form method="POST" action="{{ route('admin.products.store') }}">
                @csrf

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
                    <input type="text" name="name" required
                           class="w-full border border-gray-300 rounded px-3 py-2">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                    <textarea name="description" rows="3"
                              class="w-full border border-gray-300 rounded px-3 py-2"></textarea>
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                    <select name="category" required class="w-full border border-gray-300 rounded px-3 py-2"
                            onchange="toggleVerification(this.value)">
                        <option value="">Select Category</option>
                        <option value="medicine">Medicine (Requires Verification)</option>
                        <option value="equipment">Equipment</option>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Price (TZS)</label>
                        <input type="number" name="price" required min="0" step="0.01"
                               class="w-full border border-gray-300 rounded px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Stock</label>
                        <input type="number" name="stock" required min="0"
                               class="w-full border border-gray-300 rounded px-3 py-2">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Image URL (Optional)</label>
                    <input type="text" name="image_url"
                           class="w-full border border-gray-300 rounded px-3 py-2">
                </div>

                <div class="mb-6">
                    <label class="flex items-center">
                        <input type="checkbox" name="is_active" value="1" checked
                               class="rounded border-gray-300 text-primary">
                        <span class="ml-2">Active</span>
                    </label>
                </div>

                <button type="submit" class="w-full bg-primary text-white py-2 rounded hover:bg-primary-dark">
                    Create Product
                </button>
            </form>
        </div>
    </div>

    <script>
        function toggleVerification(category) {
            // Medicines automatically require verification
        }
    </script>
@endsection
