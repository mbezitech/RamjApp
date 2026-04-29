<?php $__env->startSection('title', 'Edit Product - ' . $product->name); ?>

<?php $__env->startSection('content'); ?>
    <div class="mb-6">
        <a href="<?php echo e(route('admin.products.index')); ?>" class="text-blue-600 hover:underline">← Back to Products</a>
    </div>

    <div class="max-w-2xl">
        <div class="bg-white rounded-lg shadow p-6">
            <form method="POST" action="<?php echo e(route('admin.products.update', $product->id)); ?>">
                <?php echo csrf_field(); ?>
                <?php echo method_field('PUT'); ?>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
                    <input type="text" name="name" value="<?php echo e(old('name', $product->name)); ?>" required
                           class="w-full border border-gray-300 rounded px-3 py-2">
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                    <textarea name="description" rows="3"
                              class="w-full border border-gray-300 rounded px-3 py-2"><?php echo e(old('description', $product->description)); ?></textarea>
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                    <select name="category" required class="w-full border border-gray-300 rounded px-3 py-2">
                        <option value="medicine" <?php echo e($product->category == 'medicine' ? 'selected' : ''); ?>>Medicine (Requires Verification)</option>
                        <option value="equipment" <?php echo e($product->category == 'equipment' ? 'selected' : ''); ?>>Equipment</option>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Price (TZS)</label>
                        <input type="number" name="price" value="<?php echo e(old('price', $product->price)); ?>" required min="0" step="0.01"
                               class="w-full border border-gray-300 rounded px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Stock</label>
                        <input type="number" name="stock" value="<?php echo e(old('stock', $product->stock)); ?>" required min="0"
                               class="w-full border border-gray-300 rounded px-3 py-2">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Image URL</label>
                    <input type="text" name="image_url" value="<?php echo e(old('image_url', $product->image_url)); ?>"
                           class="w-full border border-gray-300 rounded px-3 py-2">
                </div>

                <div class="mb-6">
                    <label class="flex items-center">
                        <input type="checkbox" name="is_active" value="1" <?php echo e($product->is_active ? 'checked' : ''); ?>

                               class="rounded border-gray-300 text-blue-600">
                        <span class="ml-2">Active</span>
                    </label>
                </div>

                <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
                    Update Product
                </button>
            </form>
        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layout', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/apple/Desktop/RamjApp/backend/resources/views/admin/products/edit.blade.php ENDPATH**/ ?>