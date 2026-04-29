<?php $__env->startSection('title', 'Pending Documents'); ?>

<?php $__env->startSection('content'); ?>
    <div class="mb-6 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Pending Verifications</h1>
            <p class="text-gray-600">Review business verification documents</p>
        </div>
        <a href="<?php echo e(route('admin.documents.all')); ?>"
           class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
            View All Documents
        </a>
    </div>

    <!-- Pending Documents -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
        <?php if($documents->count() > 0): ?>
            <table class="min-w-full">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Business</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Document Type</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Uploaded</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                    <?php $__currentLoopData = $documents; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $doc): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <tr>
                            <td class="px-6 py-4">
                                <div>
                                    <p class="font-medium text-gray-900"><?php echo e($doc->user->business_name ?? $doc->user->name); ?></p>
                                    <p class="text-xs text-gray-500"><?php echo e($doc->user->email); ?></p>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 text-xs rounded-full bg-blue-100 text-blue-800">
                                    <?php echo e(strtoupper($doc->document_type)); ?>

                                </span>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-600">
                                <?php echo e($doc->created_at->format('M d, Y')); ?>

                            </td>
                            <td class="px-6 py-4">
                                <a href="<?php echo e(route('admin.documents.review', $doc->id)); ?>"
                                   class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700">
                                    Review
                                </a>
                            </td>
                        </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </tbody>
            </table>
            <div class="px-6 py-4 border-t border-gray-200">
                <?php echo e($documents->links()); ?>

            </div>
        <?php else: ?>
            <div class="p-8 text-center">
                <p class="text-gray-500">No pending documents</p>
            </div>
        <?php endif; ?>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layout', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/apple/Desktop/RamjApp/backend/resources/views/admin/documents/pending.blade.php ENDPATH**/ ?>