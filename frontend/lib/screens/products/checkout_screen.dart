import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../orders/orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ApiService _apiService = ApiService();
  final _facilityController = TextEditingController();
  final _departmentController = TextEditingController();
  final _recipientController = TextEditingController();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _poNumberController = TextEditingController();
  String _paymentMethod = 'mobile_money';
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _facilityController.dispose();
    _departmentController.dispose();
    _recipientController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    _poNumberController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_addressController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter delivery address');
      return;
    }

    final cartProvider = context.read<CartProvider>();
    if (cartProvider.items.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final address = _buildFullAddress();

      await _apiService.post('/orders', {
        'items': cartProvider.toOrderItems(),
        'shipping_address': address,
        'payment_method': _paymentMethod,
      });

      cartProvider.clear();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OrdersScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('ApiException: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _buildFullAddress() {
    final parts = <String>[
      if (_facilityController.text.trim().isNotEmpty) _facilityController.text.trim(),
      if (_departmentController.text.trim().isNotEmpty) _departmentController.text.trim(),
      if (_recipientController.text.trim().isNotEmpty) 'Attn: ${_recipientController.text.trim()}',
      _addressController.text.trim(),
      if (_instructionsController.text.trim().isNotEmpty) 'Notes: ${_instructionsController.text.trim()}',
    ];
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

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
                      return _buildWideLayout(cart);
                    }
                    return _buildNarrowLayout(cart);
                  },
                ),
              ),
            ),
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
            'Checkout',
            style: AppTypography.h3.copyWith(color: AppColors.onSurface),
          ),
          const Spacer(),
          const Icon(Icons.search, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 16),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 18, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(CartProvider cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: _buildFormColumn(),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: _buildSummaryColumn(cart),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(CartProvider cart) {
    return Column(
      children: [
        _buildFormColumn(),
        const SizedBox(height: 24),
        _buildSummaryColumn(cart),
      ],
    );
  }

  Widget _buildFormColumn() {
    return Column(
      children: [
        _buildProgressStepper(),
        const SizedBox(height: 24),
        _buildShippingSection(),
        const SizedBox(height: 16),
        _buildPaymentSection(),
      ],
    );
  }

  Widget _buildProgressStepper() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stepWidth = constraints.maxWidth / 3;
          return SizedBox(
            height: 56,
            child: Stack(
              children: [
                Positioned(
                  left: stepWidth * 0.5,
                  right: stepWidth * 0.5,
                  top: 16,
                  child: Container(
                    height: 2,
                    color: AppColors.surfaceContainer,
                  ),
                ),
                Positioned(
                  left: stepWidth * 0.5,
                  top: 16,
                  width: stepWidth,
                  child: Container(
                    height: 2,
                    color: AppColors.primaryContainer,
                  ),
                ),
                Positioned.fill(
                  child: Row(
                    children: [
                      _StepDot(number: 1, label: 'Shipping', isActive: true),
                      _StepDot(number: 2, label: 'Payment', isActive: true),
                      _StepDot(number: 3, label: 'Review', isActive: false),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShippingSection() {
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
          Row(
            children: [
              const Icon(Icons.local_shipping, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Shipping Information',
                style: AppTypography.h3.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              return Column(
                children: [
                  if (isWide)
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_facilityController, 'Facility Name', 'e.g. St. Jude Medical Center')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(_departmentController, 'Department', 'e.g. Cardiology Unit')),
                      ],
                    )
                  else ...[
                    _buildTextField(_facilityController, 'Facility Name', 'e.g. St. Jude Medical Center'),
                    const SizedBox(height: 16),
                    _buildTextField(_departmentController, 'Department', 'e.g. Cardiology Unit'),
                  ],
                  const SizedBox(height: 16),
                  _buildTextField(_recipientController, 'Recipient Name', 'Full name of receiving officer'),
                  const SizedBox(height: 16),
                  _buildTextField(_addressController, 'Address', '123 Clinical Way, Medical District'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _instructionsController,
                    'Special Delivery Instructions',
                    'e.g. Dock 4, Cold Chain Receiving Required',
                    maxLines: 3,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTypography.bodyMd,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.textLight),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryContainer, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
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
          Row(
            children: [
              const Icon(Icons.payments, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Payment Method',
                style: AppTypography.h3.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          _buildPaymentOption(
            value: 'corporate_account',
            title: 'Corporate Account',
            subtitle: 'Billing ID: MED-8829',
            selectedBorder: true,
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            value: 'purchase_order',
            title: 'Purchase Order (PO)',
            subtitle: 'Net 30 Terms',
          ),
          if (_paymentMethod == 'purchase_order') ...[
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.outlineVariant),
            const SizedBox(height: 16),
            _buildTextField(_poNumberController, 'PO Number', 'Enter PO-XXXXXXXXX'),
          ],
          const SizedBox(height: 12),
          _buildPaymentOption(
            value: 'mobile_money',
            title: 'Mobile Money',
            subtitle: 'M-Pesa / Tigo Pesa / Airtel Money',
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            value: 'lipa_namba',
            title: 'Lipa Namba',
            subtitle: 'Pay with Lipa Namba',
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            value: 'credit_card',
            title: 'Credit Card',
            subtitle: 'Visa / Mastercard',
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _error!,
                style: const TextStyle(color: AppColors.error, fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    bool selectedBorder = false,
  }) {
    final isSelected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerLow : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelBold.copyWith(color: AppColors.onSurface),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(CartProvider cart) {
    final subtotal = cart.total;
    const logistics = 75.0;
    const tax = 0.0;
    final total = subtotal + logistics + tax;

    return Column(
      children: [
        Container(
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
                'Order Summary',
                style: AppTypography.h3.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...cart.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.product.isMedicine ? Icons.medication : Icons.medical_services,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Qty: ${item.quantity} units',
                            style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'TZS ${item.subtotal.toStringAsFixed(2)}',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 12),
              Container(height: 1, color: AppColors.outlineVariant),
              const SizedBox(height: 12),
              _SummaryLine(label: 'Subtotal', value: 'TZS ${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              _SummaryLine(label: 'Medical Logistics (Cold Chain)', value: 'TZS ${logistics.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              _SummaryLine(label: 'Tax (Exempt/Gov)', value: 'TZS ${tax.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              Container(height: 1, color: AppColors.outlineVariant),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'TZS ${total.toStringAsFixed(2)}',
                    style: AppTypography.bodyLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _placeOrder,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.lock, fill: 1),
            label: Text(
              _isLoading ? 'Processing...' : 'Confirm Order',
              style: AppTypography.bodyLg.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'By confirming, you agree to the MedFoot Terms of Procurement and Medical Safety Guidelines.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _TrustBadge(
                icon: Icons.verified_user,
                label: 'HIPAA COMPLIANT',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TrustBadge(
                icon: Icons.lock,
                label: 'ENCRYPTED TRANSACTION',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;

  const _StepDot({required this.number, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryContainer : AppColors.surfaceContainer,
              shape: BoxShape.circle,
              border: isActive ? null : Border.all(color: AppColors.outlineVariant, width: 2),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelMd.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        Text(value, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelBold.copyWith(
              color: AppColors.onSurface,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
