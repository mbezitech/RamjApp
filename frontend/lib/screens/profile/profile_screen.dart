import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';
import '../documents/document_upload_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryContainer.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryContainer,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: AppTypography.h3.copyWith(color: AppColors.onSurface, fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.email, size: 14, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              user.email,
                              style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                      if (user.phone != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              user.phone!,
                              style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryContainer, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Account Information',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoRow(label: 'Account Type', value: user.role.toUpperCase()),
                const Divider(height: 24, color: AppColors.outlineVariant),
                _InfoRow(
                  label: 'Verification Status',
                  value: user.isVerified ? 'Verified' : 'Not Verified',
                  valueColor: user.isVerified ? AppColors.success : AppColors.warning,
                ),
                if (user.businessName != null) ...[
                  const Divider(height: 24, color: AppColors.outlineVariant),
                  _InfoRow(label: 'Business Name', value: user.businessName!),
                ],
                if (user.businessType != null) ...[
                  const Divider(height: 24, color: AppColors.outlineVariant),
                  _InfoRow(label: 'Business Type', value: user.businessType!.toUpperCase()),
                ],
                if (user.country != null) ...[
                  const Divider(height: 24, color: AppColors.outlineVariant),
                  _InfoRow(label: 'Country', value: user.country!),
                ],
                if (user.region != null) ...[
                  const Divider(height: 24, color: AppColors.outlineVariant),
                  _InfoRow(label: 'Region', value: user.region!),
                ],
              ],
            ),
          ),
          if (user.role == 'business' && !user.isVerified) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DocumentUploadScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.upload_file),
                label: Text('Upload Verification Documents', style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.onSurfaceVariant),
                  title: Text('About', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                  subtitle: Text('${AppConstants.appName} v1.0.0',
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  trailing: Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                  onTap: () {},
                ),
                const Divider(height: 1, color: AppColors.outlineVariant),
                ListTile(
                  leading: Icon(Icons.description_outlined, color: AppColors.onSurfaceVariant),
                  title: Text('Terms & Conditions',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                  trailing: Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                  onTap: () => _showPolicySheet(context, 'Terms & Conditions', _termsContent),
                ),
                const Divider(height: 1, color: AppColors.outlineVariant),
                ListTile(
                  leading: Icon(Icons.assignment_return_outlined, color: AppColors.onSurfaceVariant),
                  title: Text('Return Policy',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                  trailing: Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                  onTap: () => _showPolicySheet(context, 'Return Policy', _returnPolicyContent),
                ),
                const Divider(height: 1, color: AppColors.outlineVariant),
                ListTile(
                  leading: Icon(Icons.headset_mic_outlined, color: AppColors.onSurfaceVariant),
                  title: Text('Support Contact',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                  subtitle: Text('Get help & contact us',
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  trailing: Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                  onTap: () => _showPolicySheet(context, 'Support Contact', _supportContent),
                ),
                const Divider(height: 1, color: AppColors.outlineVariant),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: Text('Logout',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
                  onTap: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
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
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.outlineVariant),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        content,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.8,
                        ),
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

const _termsContent = '''
These Terms and Conditions govern your use of the MedFoot medical supply platform. By creating an account and using our services, you agree to comply with these terms.

1. Account Registration
You must provide accurate and complete information when creating an account. You are responsible for maintaining the confidentiality of your login credentials and for all activities under your account.

2. Business Verification
Business accounts must submit valid TMDA (Tanzania Medicines and Medical Devices Authority) and TRA (Tanzania Revenue Authority) certificates for verification. Access to medicine catalogues is granted only after successful verification.

3. Ordering and Payments
All orders placed through the platform are subject to product availability and confirmation. Prices are listed in Tanzanian Shillings (TZS) and may change without prior notice. Payment must be completed as per the selected payment method.

4. Shipping and Delivery
Delivery timelines are estimates and not guaranteed. MedFoot is not liable for delays caused by third-party logistics providers or circumstances beyond our control.

5. Returns and Refunds
Returns are accepted within 14 days of delivery for defective or incorrect products. Medicines cannot be returned once dispatched due to regulatory requirements. Refunds are processed within 7-14 business days after inspection.

6. Limitation of Liability
MedFoot shall not be liable for any indirect, incidental, or consequential damages arising from the use of our platform or products.

7. Privacy
We collect and process personal data in accordance with our Privacy Policy. By using our platform, you consent to such processing.

8. Modifications
We reserve the right to modify these terms at any time. Users will be notified of material changes via email or platform notification.
''';

const _returnPolicyContent = '''
Return and Refund Policy

1. Eligibility
Returns are accepted within 14 calendar days from the date of delivery. To be eligible, items must be unused, in original packaging, and accompanied by proof of purchase.

2. Non-Returnable Items
The following items cannot be returned:
- Medicines and pharmaceutical products (once dispatched)
- Custom or special-order equipment
- Items with broken seals or opened packaging
- Products past their expiration date

3. Return Process
To initiate a return, contact our support team with your order number and reason for return. Our team will provide a Return Merchandise Authorization (RMA) number and instructions.

4. Inspection and Refund
Upon receiving returned items, we inspect them within 3-5 business days. Approved refunds are processed to the original payment method within 7-14 business days.

5. Damaged or Incorrect Items
If you receive damaged or incorrect items, notify us within 48 hours of delivery. Include photographic evidence. We will arrange a replacement or full refund including shipping costs.

6. Shipping Costs
Return shipping costs are borne by the customer unless the return is due to our error or defective product.
''';

const _supportContent = '''
We're here to help. Reach out to our support team through any of the following channels:

📧 Email Support
support@medfoot.ramjlimited.com
Response time: Within 24 hours

📞 Phone Support
+255 123 456 789
Available Monday - Friday: 8:00 AM - 5:00 PM (EAT)

💬 Live Chat
Available on the MedFoot platform during business hours.

📍 Physical Address
MedFoot Medical Supply Platform
Dar es Salaam, Tanzania

🤝 Technical Support
For technical issues or account-related queries:
tech@medfoot.ramjlimited.com

For urgent matters, please use the phone support line for immediate assistance.
''';

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        Text(
          value,
          style: AppTypography.bodySm.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
