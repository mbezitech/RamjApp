<?php $__env->startSection('title', 'All Documents'); ?>

<?php $__env->startSection('content'); ?>
    <div class="mb-6 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">All Documents</h1>
            <p class="text-gray-600">Manage verification documents</p>
        </div>
        <a href="<?php echo e(route('admin.documents.pending')); ?>"
           class="bg-yellow-600 text-white px-4 py-2 rounded hover:bg-yellow-700">
            View Pending Only
        </a>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <form method="GET" class="flex gap-4 items-end">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                <select name="status" class="border border-gray-300 rounded px-3 py-2">
                    <option value="all">All Status</option>
                    <option value="pending" <?php echo e(request('status') == 'pending' ? 'selected' : ''); ?>>Pending</option>
                    <option value="approved" <?php echo e(request('status') == 'approved' ? 'selected' : ''); ?>>Approved</option>
                    <option value="rejected" <?php echo e(request('status') == 'rejected' ? 'selected' : ''); ?>>Rejected</option>
                </select>
            </div>
            <button type="submit" class="bg-primary text-white px-4 py-2 rounded hover:bg-primary-dark">
                Filter
            </button>
        </form>
    </div>

    <!-- Documents Table -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
        <table class="min-w-full">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Business</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Type</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
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
                             <span class="px-2 py-1 text-xs rounded-full bg-primary-bg text-primary-text">
                                 <?php echo e(strtoupper($doc->document_type)); ?>

                             </span>
                        </td>
                        <td class="px-6 py-4">
                            <span class="px-2 py-1 text-xs rounded-full
                                <?php if($doc->status == 'approved'): ?> bg-green-100 text-green-800
                                <?php elseif($doc->status == 'rejected'): ?> bg-red-100 text-red-800
                                <?php else: ?> bg-yellow-100 text-yellow-800 <?php endif; ?>">
                                <?php echo e(ucfirst($doc->status)); ?>

                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600"><?php echo e($doc->created_at->format('M d, Y')); ?></td>
                        <td class="px-6 py-4">
                             <a href="<?php echo e(route('admin.documents.review', $doc->id)); ?>"
                                class="text-primary hover:underline text-sm">
                                 <?php if($doc->status == 'pending'): ?> Review <?php else: ?> View <?php endif; ?>
                             </a>
                        </td>
                    </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </tbody>
        </table>
        <div class="px-6 py-4 border-t border-gray-200">
            <?php echo e($documents->links()); ?>

        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layout', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/apple/Desktop/RamjApp/backend/resources/views/admin/documents/all.blade.php ENDPATH**/ ?>