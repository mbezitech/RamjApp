import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import 'product_detail_screen.dart';
import '../documents/document_upload_screen.dart';
import 'cart_screen.dart';
import '../../widgets/app_bottom_nav.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiService _apiService = ApiService();
  final _searchController = TextEditingController();

  List<Product> _products = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String _sortBy = 'name';
  String? _error;
  bool _canAccessMedicines = false;
  bool _inStockOnly = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      _canAccessMedicines = authProvider.canAccessMedicines;

      final queryParams = <String, String>{
        'per_page': '50',
        'sort': _sortBy,
      };
      if (_selectedCategory != 'all') {
        queryParams['category'] = _selectedCategory;
      }
      if (_searchQuery.isNotEmpty) {
        queryParams['search'] = _searchQuery;
      }
      if (_inStockOnly) {
        queryParams['in_stock'] = 'true';
      }

      final response = await _apiService.get('/products', queryParams: queryParams);

      setState(() {
        _products = (response['products'] as List)
            .map((p) => Product.fromJson(p))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('ApiException: ', '');
        _isLoading = false;
      });
    }
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();
    final isSearchActive = _searchQuery.isNotEmpty || _inStockOnly || _selectedCategory != 'all';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(cartProvider, authProvider),
          if (authProvider.user?.role == 'business' && !authProvider.isVerifiedBusiness)
            _buildVerificationBanner(),
          Expanded(
            child: _buildBody(isSearchActive),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildAppBar(CartProvider cartProvider, AuthProvider authProvider) {
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
              onTap: () => _showFilterSheet(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.menu, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'MedFoot',
              style: AppTypography.h3.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (!authProvider.isVerifiedBusiness && authProvider.user?.role == 'business')
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DocumentUploadScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.verified_outlined, color: AppColors.primary),
                ),
              ),
            const SizedBox(width: 8),
            if (_searchQuery.isEmpty && !_inStockOnly)
              GestureDetector(
                onTap: () {
                  setState(() => _inStockOnly = false);
                  _showFilterSheet(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.search, color: AppColors.primary),
                ),
              ),
            const SizedBox(width: 8),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shopping_cart, color: AppColors.primary),
                  ),
                ),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${cartProvider.itemCount}',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppColors.warning.withOpacity(0.15),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: AppColors.warning, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Account pending verification. Upload TMDA & TRA documents to access medicines.',
              style: AppTypography.bodySm.copyWith(color: AppColors.warning),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DocumentUploadScreen()),
              );
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(bool isSearchActive) {
    if (_isLoading && _products.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_error != null && _products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(_error!, style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final filteredProducts = _products.where((p) {
      if (_inStockOnly && p.stock <= 0) return false;
      if (_selectedCategory != 'all' && p.category != _selectedCategory) return false;
      return true;
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadProducts,
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          _buildHeroBanner(),
          _buildCategories(),
          if (_searchQuery.isNotEmpty || _inStockOnly)
            _buildActiveFilters(),
          if (filteredProducts.isEmpty && !_isLoading)
            _buildEmptyState()
          else
            _buildProductGrid(filteredProducts),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.onSurface,
              AppColors.onSurface.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -40,
                child: Icon(
                  Icons.medical_services,
                  size: 200,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Icon(
                  Icons.biotech,
                  size: 120,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'Next-Gen Diagnostic Tools',
                        style: AppTypography.h2.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'Precision engineering for modern clinical excellence.',
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Explore Tech',
                        style: AppTypography.bodyMd.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildCategories() {
    final categories = [
      {'value': 'all', 'label': 'All', 'icon': Icons.grid_view},
      {'value': 'equipment', 'label': 'Equipment', 'icon': Icons.medical_services},
    ];
    if (_canAccessMedicines) {
      categories.add({'value': 'medicine', 'label': 'Medicine', 'icon': Icons.medication});
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Categories',
                style: AppTypography.h3.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: GestureDetector(
                  onTap: () => _selectCategory('all'),
                  child: Text(
                    'View All',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 88,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat['value'];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => _selectCategory(cat['value'] as String),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: AppColors.onPrimary,
                            fill: isSelected ? 1.0 : 0.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['label'] as String,
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (_searchQuery.isNotEmpty)
              _FilterBadge(label: '"$_searchQuery"', onRemove: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
                _loadProducts();
              }),
            if (_inStockOnly)
              _FilterBadge(label: 'In Stock', onRemove: () {
                setState(() => _inStockOnly = false);
                _loadProducts();
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.inventory_2_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? 'No results for "$_searchQuery"' : 'No products available',
              style: AppTypography.bodyMd.copyWith(color: AppColors.textLight),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                  _loadProducts();
                },
                child: const Text('Clear search'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _searchQuery.isNotEmpty ? 'Search Results' : 'Featured Products',
            style: AppTypography.h3.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 24) / 2;
              final aspectRatio = cardWidth / 440;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => _ProductCard(product: products[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Search & Filters',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _inStockOnly = false;
                            _sortBy = 'name';
                            _selectedCategory = 'all';
                            _searchController.clear();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const Divider(),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setModalState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Availability',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SwitchListTile(
                    title: const Text('In Stock Only'),
                    value: _inStockOnly,
                    activeColor: AppColors.primary,
                    onChanged: (value) => setModalState(() => _inStockOnly = value),
                  ),
                  const Divider(),
                  Text('Sort By',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _SortOption(label: 'Name (A-Z)', value: _sortBy == 'name',
                    onTap: () => setModalState(() => _sortBy = 'name')),
                  _SortOption(label: 'Price: Low to High', value: _sortBy == 'price_low',
                    onTap: () => setModalState(() => _sortBy = 'price_low')),
                  _SortOption(label: 'Price: High to Low', value: _sortBy == 'price_high',
                    onTap: () => setModalState(() => _sortBy = 'price_high')),
                  _SortOption(label: 'Newest First', value: _sortBy == 'newest',
                    onTap: () => setModalState(() => _sortBy = 'newest')),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _searchQuery = _searchController.text.trim();
                        });
                        _loadProducts();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply Filters'),
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

class _FilterBadge extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterBadge({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.labelBold.copyWith(
            color: AppColors.primary, fontSize: 11,
          )),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback onTap;

  const _SortOption({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: AppColors.primary,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final inStock = product.stock > 0;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 192,
              color: AppColors.surfaceContainerLowest,
              child: Stack(
                children: [
                  if (product.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (_, __, ___) => _PlaceholderImage(product: product),
                    )
                  else
                    _PlaceholderImage(product: product),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: inStock ? AppColors.primary : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        inStock ? 'IN STOCK' : 'OUT OF STOCK',
                        style: AppTypography.labelBold.copyWith(
                          color: inStock ? AppColors.onPrimary : AppColors.secondary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.outline,
                      fontSize: 10,
                      letterSpacing: 0.05,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PRICE',
                                style: AppTypography.labelBold.copyWith(
                                  color: AppColors.outline, fontSize: 9,
                                ),
                              ),
                              Text('TZS ${product.price.toStringAsFixed(0)}',
                                style: AppTypography.bodySm.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('STOCK',
                                style: AppTypography.labelBold.copyWith(
                                  color: AppColors.outline, fontSize: 9,
                                ),
                              ),
                              Text('${product.stock} Units',
                                style: AppTypography.bodySm.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: inStock
                          ? () {
                              cartProvider.add(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} added to cart'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor: AppColors.surfaceContainerHigh,
                        disabledForegroundColor: AppColors.secondary,
                      ),
                      child: Text(
                        inStock ? 'Add to Cart' : 'Out of Stock',
                        style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final Product product;

  const _PlaceholderImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withOpacity(0.08),
      child: Center(
        child: Icon(
          product.isMedicine ? Icons.medication : Icons.medical_services,
          size: 48,
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
    );
  }
}
