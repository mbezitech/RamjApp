<?php $__env->startSection('title', 'Dashboard'); ?>

<?php $__env->startSection('content'); ?>
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-800">Dashboard</h1>
        <p class="text-gray-600">Overview of your medical platform</p>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div class="bg-white rounded-lg shadow p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600">Total Users</p>
                    <p class="text-3xl font-bold text-gray-800"><?php echo e($stats['total_users']); ?></p>
                </div>
                <div class="bg-primary-bg p-3 rounded-full">
                    <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                    </svg>
                </div>
            </div>
            <a href="<?php echo e(route('admin.users.index')); ?>" class="text-sm text-primary hover:underline mt-2 block">View all users →</a>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600">Verified Businesses</p>
                    <p class="text-3xl font-bold text-green-600"><?php echo e($stats['verified_businesses']); ?></p>
                </div>
                <div class="bg-green-100 p-3 rounded-full">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600">Total Products</p>
                    <p class="text-3xl font-bold text-purple-600"><?php echo e($stats['total_products']); ?></p>
                    <p class="text-xs text-gray-500 mt-1"><?php echo e($stats['medicines']); ?> medicines, <?php echo e($stats['equipment']); ?> equipment</p>
                </div>
                <div class="bg-purple-100 p-3 rounded-full">
                    <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                    </svg>
                </div>
            </div>
            <a href="<?php echo e(route('admin.products.index')); ?>" class="text-sm text-primary hover:underline mt-2 block">Manage products →</a>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600">Total Orders</p>
                    <p class="text-3xl font-bold text-orange-600"><?php echo e($stats['total_orders']); ?></p>
                    <p class="text-xs text-gray-500 mt-1"><?php echo e($stats['pending_orders']); ?> pending</p>
                </div>
                <div class="bg-orange-100 p-3 rounded-full">
                    <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                    </svg>
                </div>
            </div>
            <a href="<?php echo e(route('admin.orders.index')); ?>" class="text-sm text-primary hover:underline mt-2 block">View all orders →</a>
        </div>
    </div>

    <!-- Pending Documents -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-800">Pending Verifications</h2>
            </div>
            <div class="p-6">
                <?php if($pendingDocuments->count() > 0): ?>
                    <?php $__currentLoopData = $pendingDocuments; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $doc): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <div class="flex items-center justify-between py-3 <?php echo e(!$loop->last ? 'border-b border-gray-100' : ''); ?>">
                            <div>
                                <p class="font-medium text-gray-800"><?php echo e($doc->user->business_name ?? $doc->user->name); ?></p>
                                <p class="text-sm text-gray-600"><?php echo e(strtoupper($doc->document_type)); ?> Certificate</p>
                                <p class="text-xs text-gray-500"><?php echo e($doc->created_at->diffForHumans()); ?></p>
                            </div>
                             <a href="<?php echo e(route('admin.documents.review', $doc->id)); ?>"
                                class="bg-primary text-white px-3 py-1 rounded text-sm hover:bg-primary-dark">
                                 Review
                             </a>
                        </div>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                <?php else: ?>
                    <p class="text-gray-500 text-center py-4">No pending verifications</p>
                <?php endif; ?>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-800">Recent Orders</h2>
            </div>
            <div class="p-6">
                <?php if($recentOrders->count() > 0): ?>
                    <?php $__currentLoopData = $recentOrders; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $order): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <div class="flex items-center justify-between py-3 <?php echo e(!$loop->last ? 'border-b border-gray-100' : ''); ?>">
                            <div>
                                <p class="font-medium text-gray-800"><?php echo e($order->order_number); ?></p>
                                <p class="text-sm text-gray-600"><?php echo e($order->user->name); ?></p>
                                <p class="text-xs text-gray-500">TZS <?php echo e(number_format($order->total_amount, 0)); ?></p>
                            </div>
                             <span class="px-2 py-1 text-xs rounded-full
                                 <?php if($order->status == 'delivered'): ?> bg-green-100 text-green-800
                                 <?php elseif($order->status == 'cancelled'): ?> bg-red-100 text-red-800
                                 <?php elseif($order->status == 'shipped'): ?> bg-primary-bg text-primary-text
                                 <?php elseif($order->status == 'processing'): ?> bg-yellow-100 text-yellow-800
                                 <?php else: ?> bg-gray-100 text-gray-800 <?php endif; ?>">
                                 <?php echo e(ucfirst($order->status)); ?>

                             </span>
                        </div>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                <?php else: ?>
                    <p class="text-gray-500 text-center py-4">No orders yet</p>
                <?php endif; ?>
            </div>
        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layout', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/apple/Desktop/RamjApp/backend/resources/views/admin/dashboard.blade.php ENDPATH**/ ?>