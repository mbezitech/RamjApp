import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../utils/countries.dart';
import '../products/product_list_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();

  String _role = 'customer';
  String _businessType = 'pharmacy';
  String? _selectedCountry;
  String? _selectedRegion;
  bool _isLoading = false;
  String? _error;

  List<String> get _regions {
    if (_selectedCountry == null) return [];
    final country = countries.where((c) => c.name == _selectedCountry).firstOrNull;
    return country?.regions ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
            role: _role,
            phone: _phoneController.text.trim(),
            businessName: _businessNameController.text.trim(),
            businessType: _businessType,
            country: _selectedCountry,
            region: _selectedRegion,
          );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ProductListScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      String errorMsg = e.toString();
      if (errorMsg.contains('ApiException: ')) {
        errorMsg = errorMsg.replaceFirst('ApiException: ', '');
      }
      if (errorMsg.contains('(Status:')) {
        errorMsg = errorMsg.substring(0, errorMsg.indexOf('(Status:')).trim();
      }
      if (errorMsg.isEmpty || errorMsg == 'An error occurred') {
        errorMsg = 'Registration failed. Please try again.';
      }

      if (e is ApiException && e.errors != null) {
        _showValidationError(e.errors!);
      } else {
        setState(() {
          _error = errorMsg;
          _isLoading = false;
        });
      }
    }
  }

  void _showValidationError(Map<String, dynamic> errors) {
    final messages = errors.values
        .expand((v) => v is List ? v.map((e) => e.toString()) : [v.toString()]);
    setState(() {
      _error = messages.join('\n');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 768;
            return Row(
              children: [
                if (isWide) _buildHeroSection(),
                _buildFormSection(isWide),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: MediaQuery.of(context).size.width >= 1200
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.5,
      color: AppColors.primaryContainer,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryContainer,
                      AppColors.primaryContainer,
                      AppColors.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryContainer,
                    AppColors.error,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.medical_services, size: 48, color: AppColors.onPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'MedFoot',
                      style: AppTypography.h1.copyWith(color: AppColors.onPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Precision Logistics for Modern Medicine.',
                  style: AppTypography.h2.copyWith(color: AppColors.onPrimary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Join the elite network of healthcare providers optimizing clinical supply chains through rigorous data and surgical accuracy.',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.onPrimary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(bool isWide) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 40 : 24),
        child: SizedBox(
          width: isWide ? null : double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isWide) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.medical_services, size: 32, color: AppColors.primaryContainer),
                    const SizedBox(width: 6),
                    Text(
                      'MedFoot',
                      style: AppTypography.h2.copyWith(color: AppColors.primaryContainer, fontSize: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              Text(
                'Create Provider Account',
                style: AppTypography.h2.copyWith(color: AppColors.onSurface, fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                'Access the enterprise orthopedic equipment marketplace.',
                style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildAccountTypeSelector(),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'FULL NAME',
                      controller: _nameController,
                      hint: 'Dr. Julian Smith',
                      validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    if (_role == 'business') ...[
                      _buildField(
                        label: 'HOSPITAL/CLINIC NAME',
                        controller: _businessNameController,
                        hint: 'St. Central Medical Center',
                        validator: (v) {
                          if (_role == 'business' && (v == null || v.isEmpty)) {
                            return 'Please enter your business name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildBusinessTypeDropdown(),
                      const SizedBox(height: 16),
                    ],
                    _buildCountryField(),
                    const SizedBox(height: 16),
                    if (_selectedCountry != null && _regions.isNotEmpty) ...[
                      _buildRegionField(),
                      const SizedBox(height: 16),
                    ],
                    _buildField(
                      label: 'PHONE NUMBER',
                      controller: _phoneController,
                      hint: '+255 XXX XXX XXX',
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'PROFESSIONAL EMAIL',
                      controller: _emailController,
                      hint: 'jsmith@medical-org.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter your email';
                        if (!v.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'PASSWORD',
                            controller: _passwordController,
                            hint: '••••••••',
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please enter a password';
                              if (v.length < 8) return 'At least 8 characters';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            label: 'CONFIRM',
                            controller: _confirmPasswordController,
                            hint: '••••••••',
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please confirm your password';
                              if (v != _passwordController.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_role == 'business') ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: AppColors.warning, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Business accounts require TMDA & TRA certification',
                                style: AppTypography.bodySm.copyWith(color: AppColors.warning),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: AppTypography.bodySm.copyWith(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _buildSecurityBadge(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Create Account',
                                style: AppTypography.h3.copyWith(color: AppColors.onPrimary, fontSize: 18),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Already have a clinical account? ',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            'Login',
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.outlineVariant)),
                ),
                child: Column(
                  children: [
                    Text(
                      'MedFoot Clinical Interface v1.0.0',
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Terms of Service',
                          style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCOUNT TYPE',
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _RoleCard(
                icon: Icons.person_outline,
                label: 'Customer',
                subtitle: 'Buy equipment',
                isSelected: _role == 'customer',
                onTap: () => setState(() => _role = 'customer'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RoleCard(
                icon: Icons.business_center_outlined,
                label: 'Business',
                subtitle: 'Medicines & equipment',
                isSelected: _role == 'business',
                onTap: () => setState(() => _role = 'business'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COUNTRY',
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _selectedCountry,
          isExpanded: true,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          dropdownColor: AppColors.surface,
          hint: Text(
            'Select your country',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              borderSide: BorderSide(color: AppColors.primaryContainer, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
          items: countries.map((country) {
            return DropdownMenuItem(
              value: country.name,
              child: Text(country.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
              _selectedRegion = null;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please select your country';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REGION',
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _selectedRegion,
          isExpanded: true,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          dropdownColor: AppColors.surface,
          hint: Text(
            'Select your region',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              borderSide: BorderSide(color: AppColors.primaryContainer, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
          items: _regions.map((region) {
            return DropdownMenuItem(
              value: region,
              child: Text(region),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedRegion = value);
          },
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              borderSide: BorderSide(color: AppColors.primaryContainer, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildBusinessTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BUSINESS TYPE',
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _businessType,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          dropdownColor: AppColors.surface,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              borderSide: BorderSide(color: AppColors.primaryContainer, width: 2),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'pharmacy', child: Text('Pharmacy')),
            DropdownMenuItem(value: 'hospital', child: Text('Hospital')),
            DropdownMenuItem(value: 'clinic', child: Text('Clinic')),
            DropdownMenuItem(value: 'other', child: Text('Other')),
          ],
          onChanged: (value) => setState(() => _businessType = value!),
        ),
      ],
    );
  }

  Widget _buildSecurityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user,
            size: 20,
            color: AppColors.primaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            'Enterprise-grade data protection active',
            style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryFixed : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryContainer : AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.labelMd.copyWith(
                color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
