import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';
import '../auth/login_screen.dart';
import '../orders/orders_screen.dart';
import '../../widgets/app_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  List<Order> _recentOrders = [];
  bool _ordersLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentOrders();
  }

  Future<void> _loadRecentOrders() async {
    try {
      final response = await _apiService.get('/orders', queryParams: {'per_page': '5', 'sort': 'newest'});
      setState(() {
        _recentOrders = (response['orders'] as List).map((o) => Order.fromJson(o)).toList();
        _ordersLoading = false;
      });
    } catch (_) {
      setState(() => _ordersLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final activeOrders = _recentOrders.length;
    final ordersLast30 = _recentOrders.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 80),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1280),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildProfileHeader(user, authProvider),
                    const SizedBox(height: 24),
                    _buildBentoGrid(user, authProvider),
                    const SizedBox(height: 32),
                    _buildAccountManagement(authProvider),
                    const SizedBox(height: 32),
                    _buildPoliciesSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          _buildAppBar(authProvider),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const AppBottomNav(currentIndex: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AuthProvider authProvider) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(bottom: BorderSide(color: AppColors.surfaceVariant)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.primaryContainer),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Profile', style: AppTypography.h3.copyWith(color: AppColors.primaryContainer)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(Icons.settings, color: AppColors.primaryContainer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user, AuthProvider authProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;
        return Row(
          crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _buildAvatar(user),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: AppTypography.h1.copyWith(color: AppColors.onSurface, fontSize: 32),
                    textAlign: isWide ? TextAlign.start : TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.role == 'business' ? 'Medical Professional' : 'Customer',
                    style: AppTypography.bodyLg.copyWith(color: AppColors.secondary),
                  ),
                  const SizedBox(height: 8),
                  if (user.businessName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_hospital, size: 16, color: AppColors.primaryContainer),
                          const SizedBox(width: 6),
                          Text(
                            user.businessName!,
                            style: AppTypography.labelBold.copyWith(color: AppColors.primaryContainer),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (isWide)
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text('Edit Profile', style: AppTypography.labelBold.copyWith(color: AppColors.onPrimary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAvatar(User user) {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
          ),
          child: CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              user.name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (user.isVerified)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildBentoGrid(User user, AuthProvider authProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _buildCredentialsCard(user)),
              const SizedBox(width: 24),
              Expanded(flex: 8, child: _buildRightPanel(user, authProvider)),
            ],
          );
        }
        return Column(
          children: [
            _buildCredentialsCard(user),
            const SizedBox(height: 24),
            _buildRightPanel(user, authProvider),
          ],
        );
      },
    );
  }

  Widget _buildCredentialsCard(User user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Text('Professional Credentials', style: AppTypography.h3.copyWith(color: AppColors.onSurface, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.surfaceVariant.withOpacity(0.5)),
          const SizedBox(height: 16),
          _credentialItem('Email', user.email),
          const SizedBox(height: 16),
          _credentialItem('Phone', user.phone ?? 'Not provided'),
          const SizedBox(height: 16),
          _credentialItem('Role', user.role.toUpperCase()),
                  if (user.role == 'business' && user.businessType != null) ...[
            const SizedBox(height: 16),
            _credentialItem('Business Type', user.businessType!.toUpperCase()),
          ],
          if (user.country != null) ...[
            const SizedBox(height: 16),
            _credentialItem('Country', user.country!),
          ],
          if (user.region != null) ...[
            const SizedBox(height: 16),
            _credentialItem('Region', user.region!),
          ],
          const SizedBox(height: 16),
          _credentialItem(
            'Verification',
            user.isVerified ? 'Verified' : 'Pending',
            valueColor: user.isVerified ? AppColors.success : AppColors.warning,
            icon: user.isVerified ? Icons.check_circle : Icons.pending,
          ),
        ],
      ),
    );
  }

  Widget _credentialItem(String label, String value, {Color? valueColor, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelMd.copyWith(color: AppColors.secondary, letterSpacing: 0.05),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: valueColor ?? AppColors.primaryContainer),
              const SizedBox(width: 4),
            ],
            Text(value, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600, color: valueColor ?? AppColors.onSurface)),
          ],
        ),
      ],
    );
  }

  Widget _buildRightPanel(User user, AuthProvider authProvider) {
    return Column(
      children: [
        _buildActivityCard(),
        const SizedBox(height: 24),
        _buildSettingsGrid(user, authProvider),
      ],
    );
  }

  Widget _buildActivityCard() {
    final activeOrders = _recentOrders.where((o) => o.status != 'delivered' && o.status != 'cancelled').length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text('Procurement Activity', style: AppTypography.h3.copyWith(color: AppColors.onSurface, fontSize: 20)),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrdersScreen())),
                  child: Text('View All History', overflow: TextOverflow.ellipsis, style: AppTypography.labelBold.copyWith(color: AppColors.primaryContainer)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.surfaceVariant.withOpacity(0.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Active Orders', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
                      const SizedBox(height: 4),
                      Text('$activeOrders', style: AppTypography.h2.copyWith(color: AppColors.primaryContainer)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Orders (Total)', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
                      const SizedBox(height: 4),
                      Text('${_recentOrders.length}', style: AppTypography.h2.copyWith(color: AppColors.onSurface)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_ordersLoading)
            const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 2)))
          else if (_recentOrders.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No recent orders',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.surface),
                columnSpacing: 32,
                columns: [
                  DataColumn(label: Text('ORDER ID', style: AppTypography.labelBold.copyWith(color: AppColors.secondary))),
                  DataColumn(label: Text('ITEM', style: AppTypography.labelBold.copyWith(color: AppColors.secondary))),
                  DataColumn(label: Text('STATUS', style: AppTypography.labelBold.copyWith(color: AppColors.secondary))),
                  DataColumn(label: Text('DATE', style: AppTypography.labelBold.copyWith(color: AppColors.secondary))),
                ],
                rows: _recentOrders.take(5).map((order) {
                  final firstItem = order.items.isNotEmpty ? order.items.first.product.name : 'N/A';
                  return DataRow(cells: [
                    DataCell(Text(order.orderNumber, style: AppTypography.bodySm.copyWith(color: AppColors.onSurface))),
                    DataCell(Text(firstItem, style: AppTypography.bodySm.copyWith(color: AppColors.onSurface))),
                    DataCell(_statusBadge(order.status)),
                    DataCell(Text(
                      '${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}',
                      style: AppTypography.bodySm.copyWith(color: AppColors.secondary),
                    )),
                  ]);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'shipped':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
        break;
      case 'processing':
        bg = AppColors.primaryContainer.withOpacity(0.1);
        fg = AppColors.primaryContainer;
        break;
      case 'delivered':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
        break;
      case 'cancelled':
        bg = AppColors.errorContainer;
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.warning.withOpacity(0.1);
        fg = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(), style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSettingsGrid(User user, AuthProvider authProvider) {
    return Column(
      children: [
        _buildNotificationsCard(),
        const SizedBox(height: 24),
        _buildSecurityCard(),
      ],
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Text('Notifications', style: AppTypography.h3.copyWith(color: AppColors.onSurface, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          _toggleRow('Order Updates', true),
          const SizedBox(height: 12),
          _toggleRow('Inventory Alerts', true),
          const SizedBox(height: 12),
          _toggleRow('Security Alerts', false),
        ],
      ),
    );
  }

  Widget _toggleRow(String label, bool enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: enabled ? AppColors.onSurface : AppColors.secondary)),
        Container(
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            color: enabled ? AppColors.primaryContainer : AppColors.secondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: enabled ? 21 : 1,
                top: 1,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Text('Security', style: AppTypography.h3.copyWith(color: AppColors.onSurface, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          _securityItem('Two-Factor Auth', trailing: Text('On', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(height: 12),
          _securityItem('Change Password', showChevron: true),
          const SizedBox(height: 12),
          _securityItem('Device History', showChevron: true),
        ],
      ),
    );
  }

  Widget _securityItem(String label, {Widget? trailing, bool showChevron = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.onSurface)),
          trailing ?? (showChevron ? Icon(Icons.chevron_right, size: 18, color: AppColors.secondary) : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildAccountManagement(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: AppColors.surfaceVariant),
        const SizedBox(height: 24),
        Text(
          'ACCOUNT MANAGEMENT',
          style: AppTypography.labelBold.copyWith(color: AppColors.secondary, letterSpacing: 0.05),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout, size: 16),
              label: Text('Sign Out', style: AppTypography.labelBold.copyWith(color: AppColors.secondary)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: BorderSide(color: AppColors.surfaceVariant),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            if (userCanDeactivate(authProvider))
              TextButton(
                onPressed: () {},
                child: Text(
                  'Deactivate Professional Account',
                  style: AppTypography.labelBold.copyWith(color: AppColors.error),
                ),
              ),
          ],
        ),
      ],
    );
  }

  bool userCanDeactivate(AuthProvider authProvider) {
    return authProvider.user?.role == 'business';
  }

  Widget _buildPoliciesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: AppColors.surfaceVariant),
        const SizedBox(height: 24),
        Text(
          'POLICIES & SUPPORT',
          style: AppTypography.labelBold.copyWith(color: AppColors.secondary, letterSpacing: 0.05),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Column(
            children: [
              _policyItem(Icons.description, 'Our Policies', () => _showPolicySheet(context, 'Our Policies', _policiesContent)),
              Container(height: 1, color: AppColors.surfaceVariant),
              _policyItem(Icons.replay, 'Return Policy', () => _showPolicySheet(context, 'Return Policy', _returnPolicyContent)),
              Container(height: 1, color: AppColors.surfaceVariant),
              _policyItem(Icons.support_agent, 'Support', () => _showPolicySheet(context, 'Support', _supportContent)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _policyItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryContainer),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
            const Spacer(),
            Icon(Icons.chevron_right, size: 18, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }

  void _showPolicySheet(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(title, style: AppTypography.h3.copyWith(color: AppColors.primary)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: AppColors.surfaceVariant),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        content,
                        style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface, height: 1.7),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

const String _policiesContent = '''
At MedFoot, we are committed to providing high-quality medical supplies and equipment to healthcare professionals worldwide.

Quality Assurance
All products listed on our platform undergo rigorous quality checks to ensure they meet international medical standards. We partner exclusively with verified manufacturers and suppliers.

Privacy Policy
Your privacy is important to us. We collect and process personal data in accordance with applicable data protection laws. Your information is used solely for order processing, account management, and service improvement.

Terms of Use
By using MedFoot, you agree to comply with our terms and conditions. All users must provide accurate information during registration. Business accounts require valid documentation for verification.

Shipping Policy
Orders are processed within 1-2 business days. Delivery times vary based on location and product availability. International shipments may be subject to customs clearance procedures.

For any questions regarding our policies, please contact our support team.
''';

const String _returnPolicyContent = '''
Return and Refund Policy

Eligibility
Returns are accepted within 14 days of delivery for most products. Items must be unopened, unused, and in their original packaging.

Non-Returnable Items
The following items cannot be returned: opened medical supplies, custom-configured equipment, sterile products with broken seals, and software licenses.

Return Process
1. Contact our support team to initiate a return
2. Receive a Return Authorization Number (RMA)
3. Pack the item securely in its original packaging
4. Ship to the address provided by our team

Refunds
Refunds are processed within 5-10 business days after we receive and inspect the returned item. The refund will be issued to the original payment method.

Shipping Costs
Return shipping costs are borne by the customer unless the return is due to a defect or error on our part.

Warranty Claims
For warranty-related issues, please contact our support team with your order number and a description of the issue. Warranty periods vary by product.
''';

const String _supportContent = '''
MedFoot Support Center

Contact Us
We are here to help you with any questions, issues, or feedback.

Email Support
support@medfoot.com
Response time: Within 24 hours during business days

Phone Support
+1 (555) 123-4567
Available Monday - Friday, 8:00 AM - 6:00 PM (EST)

Live Chat
Access live chat through our platform during business hours for immediate assistance.

Order Support
For order-related inquiries, please have your order number ready. You can find your order number in the order confirmation email or in your account order history.

Technical Support
For issues with platform access, account management, or technical difficulties, our IT support team is available to assist you.

Business Verification
If you need assistance with the business verification process, including TMDA and TRA document uploads, please contact our verification team at verification@medfoot.com.

We are committed to providing timely and effective support to all our customers.
''';
