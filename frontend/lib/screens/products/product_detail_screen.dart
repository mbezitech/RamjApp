import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bottom_nav.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentPage = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeroCarousel(),
                      _buildProductIdentity(),
                      _buildSpecsGrid(),
                      _buildApplications(),
                      _buildGallery(),
                      const SizedBox(height: 160),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildFloatingCtaBar(cartProvider),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: AppColors.primary),
            ),
            const SizedBox(width: 24),
            Text(
              'MedFoot',
              style: AppTypography.h3.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.search, color: AppColors.primary),
            const SizedBox(width: 24),
            const Icon(Icons.share, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCarousel() {
    final p = widget.product;
    final images = [
      p.imageUrl,
      p.imageUrl,
      p.imageUrl,
    ];

    return Container(
      color: Colors.white,
      height: 380,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: images.map((url) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: url != null
                    ? CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.contain,
                        errorWidget: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              );
            }).toList(),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == i
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: Text(
                p.isMedicine ? 'PRESCRIPTION' : 'FDA APPROVED',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 10,
                  letterSpacing: 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductIdentity() {
    final p = widget.product;
    final inStock = p.stock > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                p.category.toUpperCase(),
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.05,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: inStock ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    inStock ? 'In Stock' : 'Out of Stock',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            p.name,
            style: AppTypography.h3.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            p.description ?? 'No description available',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTag('CERTIFIED'),
              const SizedBox(width: 8),
              _buildTag('MFR WARRANTY'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        label,
        style: AppTypography.labelBold.copyWith(
          color: AppColors.onSurfaceVariant,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildSpecsGrid() {
    final p = widget.product;

    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Specifications',
            style: AppTypography.h2.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _specCard(
                  Icons.category,
                  'CATEGORY',
                  p.category.toUpperCase(),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _specCard(
                  Icons.inventory_2,
                  'STOCK',
                  '${p.stock} Units',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _specCard(
                  Icons.attach_money,
                  'PRICE',
                  '\$${p.price.toStringAsFixed(2)}',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _specCard(
                  p.isMedicine ? Icons.medication : Icons.medical_services,
                  'TYPE',
                  p.isMedicine ? 'MEDICINE' : 'EQUIPMENT',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _specCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.labelBold.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplications() {
    final p = widget.product;
    final apps = _getApplications(p);

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.isMedicine ? 'Usage Information' : 'Clinical Applications',
            style: AppTypography.h2.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          ...apps.map((app) => _applicationItem(app.icon, app.title, app.subtitle)),
        ],
      ),
    );
  }

  Widget _applicationItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.onPrimaryFixed),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Gallery',
            style: AppTypography.h2.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _galleryTile(widget.product.imageUrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _galleryTile(widget.product.imageUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _galleryTile(String? url) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: url != null
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildFloatingCtaBar(CartProvider cartProvider) {
    final p = widget.product;
    final inStock = p.stock > 0;
    final totalPrice = p.price * _quantity;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STARTING FROM',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onPrimary,
                        fontSize: 10,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: AppTypography.h3.copyWith(
                        fontSize: 20,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Icon(Icons.remove, color: _quantity > 1 ? AppColors.onPrimary : AppColors.onPrimary.withOpacity(0.4), size: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '$_quantity',
                        style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: _quantity < p.stock ? () => setState(() => _quantity++) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Icon(Icons.add, color: _quantity < p.stock ? AppColors.onPrimary : AppColors.onPrimary.withOpacity(0.4), size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: inStock
                    ? () {
                        cartProvider.add(p, quantity: _quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p.name} added to cart'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.primaryFixed),
                  ),
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                ),
                child: Text(
                  'Add to Cart',
                  style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    final p = widget.product;
    return Center(
      child: Icon(
        p.isMedicine ? Icons.medication : Icons.medical_services,
        size: 80,
        color: AppColors.primary.withOpacity(0.3),
      ),
    );
  }
}

class _Application {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Application(this.icon, this.title, this.subtitle);
}

List<_Application> _getApplications(Product product) {
  if (product.isMedicine) {
    return const [
      _Application(Icons.healing, 'Therapeutic Use',
          'Administered as directed by a licensed physician'),
      _Application(Icons.biotech, 'Clinical Efficacy',
          'Proven effectiveness in controlled trials'),
      _Application(Icons.medical_services, 'Dosage Guidelines',
          'Individualized dosing based on patient factors'),
    ];
  }
  return const [
    _Application(Icons.favorite_border, 'Diagnostic Applications',
        'High-precision imaging for accurate diagnosis'),
    _Application(Icons.biotech, 'Clinical Workflow',
        'Seamless integration with existing hospital systems'),
    _Application(Icons.precision_manufacturing, 'Quality Assurance',
        'Meets international medical device standards'),
  ];
}
