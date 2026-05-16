import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/constants.dart';
import 'checkout_screen.dart';
import '../../models/models.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: cartProvider.items.isEmpty
                  ? _buildEmpty()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth >= 768) {
                            return _buildWideLayout(context, cartProvider);
                          }
                          return _buildNarrowLayout(context, cartProvider);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant),
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
            'Shopping Cart',
            style: AppTypography.h3.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.search, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: AppTypography.bodyMd.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, CartProvider cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: _buildCartItemsColumn(cart),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: _buildOrderSummary(context, cart),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        _buildCartItemsColumn(cart),
        const SizedBox(height: 24),
        _buildOrderSummary(context, cart),
      ],
    );
  }

  Widget _buildCartItemsColumn(CartProvider cart) {
    return Column(
      children: [
        ...cart.items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _CartItemCard(item: item),
        )),
        const SizedBox(height: 24),
        _buildTrustSignals(),
      ],
    );
  }

  Widget _buildTrustSignals() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _TrustSignalCard(
                icon: Icons.verified,
                iconBg: AppColors.primaryContainer,
                iconColor: AppColors.onPrimary,
                title: 'Certified Provider Guarantee',
                subtitle: 'All equipment is FDA approved and factory sealed.',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TrustSignalCard(
                icon: Icons.security,
                iconBg: AppColors.secondary,
                iconColor: AppColors.onPrimary,
                title: 'Secure Clinical Procurement',
                subtitle: 'HIPAA compliant transaction processing.',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    final subtotal = cart.total;
    final tax = subtotal * 0.08;
    final total = subtotal + tax;
    final estimatedDelivery = DateTime.now().add(const Duration(days: 14));

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  border: Border(
                    bottom: BorderSide(color: AppColors.outlineVariant),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'Order Summary',
                  style: AppTypography.h3.copyWith(color: AppColors.onSurface),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Subtotal', value: 'TZS ${subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Estimated Tax (8%)',
                      value: 'TZS ${tax.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Medical Grade Logistics',
                                style: AppTypography.bodyMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Insured cold-chain compliant',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.outline,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'FREE',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: AppColors.outlineVariant),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTypography.h3.copyWith(color: AppColors.onSurface),
                        ),
                        Text(
                          'TZS ${total.toStringAsFixed(2)}',
                          style: AppTypography.h2.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Proceed to Checkout',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.payments),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Estimated delivery: ',
                          style: AppTypography.labelMd.copyWith(color: AppColors.outline),
                        ),
                        Text(
                          '${_month(estimatedDelivery.month)} ${estimatedDelivery.day}, ${estimatedDelivery.year}',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  border: Border(
                    top: BorderSide(color: AppColors.outlineVariant),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Procurement officers for St. Jude Medical Center receive an additional 2% credit on this order.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildLogisticsBadges(),
      ],
    );
  }

  Widget _buildLogisticsBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LogisticsBadge(icon: Icons.local_shipping, label: 'Expedited'),
        const SizedBox(width: 24),
        _LogisticsBadge(icon: Icons.medical_services, label: 'Sterilized'),
        const SizedBox(width: 24),
        _LogisticsBadge(icon: Icons.shield, label: 'Insured'),
      ],
    );
  }

  String _month(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 160,
                height: 160,
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
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: AppTypography.h3.copyWith(color: AppColors.onSurface),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'SKU: ${item.product.sku ?? 'N/A'}',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => cart.remove(item.product.id),
                          child: Icon(
                            Icons.delete,
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unit Price',
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.outline,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'TZS ${item.product.price.toStringAsFixed(2)}',
                              style: AppTypography.h3.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.outlineVariant),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.surface,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => cart.decrement(item.product.id),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 48,
                                child: Text(
                                  '${item.quantity}',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyMd.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => cart.increment(item.product.id),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.add,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        item.product.isMedicine ? Icons.medication : Icons.medical_services,
        size: 40,
        color: AppColors.primary.withOpacity(0.3),
      ),
    );
  }
}

class _TrustSignalCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _TrustSignalCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelBold.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _LogisticsBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LogisticsBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.secondary),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelBold.copyWith(
              fontSize: 10,
              letterSpacing: 1,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
