import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bottom_nav.dart';
import '../products/cart_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _getActiveStep() {
    switch (widget.order.status) {
      case 'pending':
        return 0;
      case 'processed':
        return 1;
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  String _formatDateShort(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  String _formatDateFull(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  final _api = ApiService();

  Future<void> _downloadInvoice() async {
    try {
      final bytes = await _api.downloadBytes('/orders/${widget.order.id}/invoice');
      final dir = Directory.systemTemp;
      final file = File('${dir.path}/invoice_${widget.order.orderNumber}.pdf');
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice saved to ${file.path}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${e.toString().replaceFirst('ApiException: ', '')}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  IconData _getStepIcon(int step, int activeStep) {
    if (step < activeStep) return Icons.check;
    if (step == 2 && activeStep == 2) return Icons.local_shipping;
    if (step == 3 && activeStep == 3) return Icons.inventory_2;
    if (step == activeStep) return Icons.check;
    return Icons.inventory_2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 768) {
                      return _buildWideLayout();
                    }
                    return _buildNarrowLayout();
                  },
                ),
              ),
            ),
            const AppBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceVariant),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.arrow_back, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Order #${widget.order.orderNumber.toUpperCase()}',
            style: AppTypography.h3.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          _CartAppBarButton(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.support_agent, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: _buildLeftColumn(),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: _buildRightColumn(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildLeftColumn(),
        const SizedBox(height: 24),
        _buildRightColumn(),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        _buildStatusTracking(),
        const SizedBox(height: 24),
        _buildOrderSummaryBento(),
        const SizedBox(height: 16),
        _buildItemList(),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildShippingDetails(),
        const SizedBox(height: 16),
        _buildOrderActions(),
        const SizedBox(height: 16),
        _buildVendorInfo(),
      ],
    );
  }

  Widget _buildStatusTracking() {
    final activeStep = _getActiveStep();
    final stepNames = ['Ordered', 'Processed', 'Shipped', 'Delivered'];
    final stepDates = [
      _formatDateShort(widget.order.createdAt),
      '',
      '',
      widget.order.estimatedDelivery != null
          ? _formatDateShort(widget.order.estimatedDelivery!)
          : '',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final innerWidth = constraints.maxWidth - 48;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORDER STATUS',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.secondary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 64,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 12,
                      child: Container(
                        height: 2,
                        color: AppColors.surfaceVariant,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 12,
                      child: Container(
                        height: 2,
                        width: activeStep == 3
                            ? innerWidth
                            : innerWidth * 0.33 * activeStep,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned.fill(
                      child: Row(
                        children: List.generate(4, (index) {
                          final isCompleted = index <= activeStep;
                          final isActive = index == activeStep;
                          return Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted
                                        ? AppColors.primary
                                        : AppColors.surfaceVariant,
                                    border: isActive
                                        ? Border.all(
                                            color: AppColors.primaryFixed,
                                            width: 4,
                                          )
                                        : null,
                                  ),
                                  child: Icon(
                                    _getStepIcon(index, activeStep),
                                    size: 14,
                                    color: isCompleted
                                        ? AppColors.onPrimary
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  stepNames[index],
                                  style: isActive
                                      ? AppTypography.labelBold.copyWith(
                                          color: AppColors.primary,
                                        )
                                      : AppTypography.labelMd.copyWith(
                                          color: isCompleted
                                              ? AppColors.onSurface
                                              : AppColors.secondary,
                                        ),
                                ),
                                if (stepDates[index].isNotEmpty)
                                  Text(
                                    stepDates[index],
                                    style: AppTypography.labelBold.copyWith(
                                      fontSize: 10,
                                      color: isActive
                                          ? AppColors.primary
                                          : AppColors.secondary,
                                    ),
                                  )
                                else if (isActive)
                                  Text(
                                    widget.order.status == 'shipped'
                                        ? 'In Transit'
                                        : widget.order.status == 'pending'
                                            ? 'Processing'
                                            : '',
                                    style: AppTypography.labelBold.copyWith(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummaryBento() {
    return Row(
      children: [
        Expanded(
          child: _SummaryBentoCard(
            icon: Icons.calendar_today,
            label: 'Order Date',
            value: _formatDateFull(widget.order.createdAt),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryBentoCard(
            icon: Icons.account_balance_wallet,
            label: 'Payment Method',
            value: widget.order.paymentMethod ?? 'N/A',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryBentoCard(
            icon: Icons.payments,
            label: 'Total Amount',
            value: 'TZS ${widget.order.totalAmount.toStringAsFixed(2)}',
            valueColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildItemList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(color: AppColors.surfaceVariant),
              ),
            ),
            child: Text(
              'Items in Order (${widget.order.items.length})',
              style: AppTypography.labelBold.copyWith(
                color: AppColors.onSurface,
                letterSpacing: 1,
              ),
            ),
          ),
          ...widget.order.items.map((item) => _buildOrderItemRow(item)),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(OrderItem item) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: widget.order.items.last != item
            ? Border(
                bottom: BorderSide(color: AppColors.surfaceVariant),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.product.imageUrl != null
                  ? Image.network(
                      item.product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildItemPlaceholder(item),
                    )
                  : _buildItemPlaceholder(item),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: AppTypography.h3.copyWith(color: AppColors.onSurface),
                      ),
                    ),
                    Text(
                      'SKU: ${item.sku ?? item.product.sku ?? 'N/A'}',
                      style: AppTypography.labelBold.copyWith(color: AppColors.secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.product.description ?? '',
                  style: AppTypography.bodySm.copyWith(color: AppColors.secondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity',
                          style: AppTypography.labelMd.copyWith(color: AppColors.secondary),
                        ),
                        Text(
                          '${item.quantity} Units',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unit Price',
                          style: AppTypography.labelMd.copyWith(color: AppColors.secondary),
                        ),
                        Text(
                          'TZS ${item.unitPrice.toStringAsFixed(2)}',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    _ActionTextButton(
                      icon: Icons.description,
                      label: 'Digital Manual',
                    ),
                    _ActionTextButton(
                      icon: Icons.verified_user,
                      label: 'Warranty',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHIPPING DETAILS',
            style: AppTypography.labelBold.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: AppTypography.labelBold.copyWith(color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.order.shippingAddress,
                      style: AppTypography.bodySm.copyWith(color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.surfaceVariant),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.event_available, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Delivery',
                    style: AppTypography.labelBold.copyWith(color: AppColors.onSurface),
                  ),
                  Text(
                    widget.order.estimatedDelivery != null
                        ? _formatDateFull(widget.order.estimatedDelivery!)
                        : 'N/A',
                    style: AppTypography.bodySm.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map, size: 18),
              label: Text(
                'Track Live',
                style: AppTypography.labelBold.copyWith(color: AppColors.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER ACTIONS',
            style: AppTypography.labelBold.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _downloadInvoice,
                icon: const Icon(Icons.download, size: 18),
                label: Text(
                  'Download Invoice',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSecondaryFixedVariant,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.mail, size: 18),
              label: Text(
                'Contact Vendor',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSecondaryFixedVariant,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border.all(color: AppColors.surfaceVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medical_services,
              color: AppColors.onPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.order.vendorName ?? 'MedFoot Vendor',
                style: AppTypography.labelBold.copyWith(color: AppColors.onSurface),
              ),
              Text(
                widget.order.vendorDescription ?? 'Certified Premium Supplier',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemPlaceholder(OrderItem item) {
    return Center(
      child: Icon(
        item.product.isMedicine ? Icons.medication : Icons.medical_services,
        size: 36,
        color: AppColors.primary.withOpacity(0.3),
      ),
    );
  }
}

class _SummaryBentoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryBentoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.labelMd.copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodyLg.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartAppBarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.shopping_cart, color: AppColors.primary),
          ),
        ),
        if (cartCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.warning,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$cartCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionTextButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionTextButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelBold.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
