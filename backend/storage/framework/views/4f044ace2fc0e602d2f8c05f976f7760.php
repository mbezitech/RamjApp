<?php $__env->startSection('title', 'Users'); ?>

<?php $__env->startSection('content'); ?>
    <div class="mb-6 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Users</h1>
            <p class="text-gray-600">Manage registered users</p>
        </div>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <form method="GET" class="flex gap-4 items-end">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
                <select name="role" class="border border-gray-300 rounded px-3 py-2">
                    <option value="all">All Roles</option>
                    <option value="customer" <?php echo e(request('role') == 'customer' ? 'selected' : ''); ?>>Customer</option>
                    <option value="business" <?php echo e(request('role') == 'business' ? 'selected' : ''); ?>>Business</option>
                    <option value="admin" <?php echo e(request('role') == 'admin' ? 'selected' : ''); ?>>Admin</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Verification</label>
                <select name="verified" class="border border-gray-300 rounded px-3 py-2">
                    <option value="all">All</option>
                    <option value="true" <?php echo e(request('verified') == 'true' ? 'selected' : ''); ?>>Verified</option>
                    <option value="false" <?php echo e(request('verified') == 'false' ? 'selected' : ''); ?>>Unverified</option>
                </select>
            </div>
            <button type="submit" class="bg-primary text-white px-4 py-2 rounded hover:bg-primary-dark">
                Filter
            </button>
        </form>
    </div>

    <!-- Users Table -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
        <table class="min-w-full">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Role</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
                <?php $__currentLoopData = $users; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <tr>
                        <td class="px-6 py-4">
                            <div>
                                <p class="font-medium text-gray-900"><?php echo e($user->name); ?></p>
                                <?php if($user->business_name): ?>
                                    <p class="text-xs text-gray-500"><?php echo e($user->business_name); ?></p>
                                <?php endif; ?>
                            </div>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600"><?php echo e($user->email); ?></td>
                        <td class="px-6 py-4">
                             <span class="px-2 py-1 text-xs rounded-full
                                 <?php if($user->role == 'admin'): ?> bg-purple-100 text-purple-800
                                 <?php elseif($user->role == 'business'): ?> bg-primary-bg text-primary-text
                                 <?php else: ?> bg-gray-100 text-gray-800 <?php endif; ?>">
                                 <?php echo e(ucfirst($user->role)); ?>

                             </span>
                        </td>
                        <td class="px-6 py-4">
                            <?php if($user->is_verified): ?>
                                <span class="px-2 py-1 text-xs rounded-full bg-green-100 text-green-800">Verified</span>
                            <?php else: ?>
                                <span class="px-2 py-1 text-xs rounded-full bg-yellow-100 text-yellow-800">Unverified</span>
                            <?php endif; ?>
                        </td>
                        <td class="px-6 py-4">
                             <a href="<?php echo e(route('admin.users.show', $user->id)); ?>"
                                class="text-primary hover:underline text-sm mr-3">View</a>
                            <form method="POST" action="<?php echo e(route('admin.users.destroy', $user->id)); ?>"
                                  class="inline" onsubmit="return confirm('Delete this user?')">
                                <?php echo csrf_field(); ?>
                                <?php echo method_field('DELETE'); ?>
                                <button type="submit" class="text-red-600 hover:underline text-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </tbody>
        </table>
        <div class="px-6 py-4 border-t border-gray-200">
            <?php echo e($users->links()); ?>

        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layout', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/apple/Desktop/RamjApp/backend/resources/views/admin/users/index.blade.php ENDPATH**/ ?>