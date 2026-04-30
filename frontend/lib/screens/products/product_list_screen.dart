import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import 'product_detail_screen.dart';
import '../orders/orders_screen.dart';
import '../documents/document_upload_screen.dart';
import '../profile/profile_screen.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiService _apiService = ApiService();
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<Product> _products = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String _sortBy = 'name';
  String? _error;
  bool _canAccessMedicines = false;
  bool _showFilters = false;
  bool _inStockOnly = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchQuery = query.trim());
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _isSearching = true;
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
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('ApiException: ', '');
        _isLoading = false;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();
    final isSearching = _searchQuery.isNotEmpty || _inStockOnly;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (!authProvider.isVerifiedBusiness && authProvider.user?.role == 'business')
            IconButton(
              icon: const Icon(Icons.verified_outlined),
              tooltip: 'Verify Business',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DocumentUploadScreen(),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
            onPressed: () => _showFilterSheet(context),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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
      body: Column(
        children: [
          if (authProvider.user?.role == 'business' && !authProvider.isVerifiedBusiness)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.warning.withOpacity(0.2),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Account pending verification. Upload TMDA & TRA documents to access medicines.',
                      style: TextStyle(color: AppColors.warning),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DocumentUploadScreen(),
                        ),
                      );
                    },
                    child: const Text('Upload'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          if (isSearching)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                children: [
                  Text(
                    '$_products results',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (_sortBy != 'name')
                    _FilterBadge(
                      label: 'Sort: $_sortBy',
                      onRemove: () => setState(() => _sortBy = 'name'),
                    ),
                  if (_inStockOnly)
                    _FilterBadge(
                      label: 'In Stock',
                      onRemove: () => setState(() => _inStockOnly = false),
                    ),
                  if (_searchQuery.isNotEmpty)
                    _FilterBadge(
                      label: '"$_searchQuery"',
                      onRemove: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.background,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip(
                    label: 'All',
                    selected: _selectedCategory == 'all',
                    onTap: () => _selectCategory('all'),
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: 'Equipment',
                    selected: _selectedCategory == 'equipment',
                    onTap: () => _selectCategory('equipment'),
                  ),
                  const SizedBox(width: 8),
                  if (authProvider.canAccessMedicines)
                    _CategoryChip(
                      label: 'Medicines',
                      selected: _selectedCategory == 'medicine',
                      onTap: () => _selectCategory('medicine'),
                    ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showSortOptions(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sort, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            _sortLabel,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, style: const TextStyle(color: AppColors.error)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadProducts,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _products.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _searchQuery.isNotEmpty ? Icons.search_off : Icons.inventory_2_outlined,
                                  size: 64,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No results for "$_searchQuery"'
                                      : 'No products available',
                                  style: TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                    child: const Text('Clear search'),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadProducts,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.65,
                              ),
                              itemCount: _products.length,
                              itemBuilder: (context, index) {
                                return _ProductCard(product: _products[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              );
              break;
            case 2:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  String get _sortLabel {
    switch (_sortBy) {
      case 'price_low':
        return 'Price: Low';
      case 'price_high':
        return 'Price: High';
      case 'name':
        return 'A-Z';
      case 'newest':
        return 'Newest';
      default:
        return 'Sort';
    }
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
    _loadProducts();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                      Text(
                        'Filters',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _inStockOnly = false;
                            _sortBy = 'name';
                            _selectedCategory = 'all';
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    'Availability',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('In Stock Only'),
                    subtitle: const Text('Hide out of stock items'),
                    value: _inStockOnly,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setModalState(() => _inStockOnly = value);
                    },
                  ),
                  const Divider(),
                  Text(
                    'Sort By',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _SortOption(
                    label: 'Name (A-Z)',
                    value: _sortBy == 'name',
                    onTap: () => setModalState(() => _sortBy = 'name'),
                  ),
                  _SortOption(
                    label: 'Price: Low to High',
                    value: _sortBy == 'price_low',
                    onTap: () => setModalState(() => _sortBy = 'price_low'),
                  ),
                  _SortOption(
                    label: 'Price: High to Low',
                    value: _sortBy == 'price_high',
                    onTap: () => setModalState(() => _sortBy = 'price_high'),
                  ),
                  _SortOption(
                    label: 'Newest First',
                    value: _sortBy == 'newest',
                    onTap: () => setModalState(() => _sortBy = 'newest'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                        _loadProducts();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _SortOption(
                      label: 'Name (A-Z)',
                      value: _sortBy == 'name',
                      onTap: () {
                        setState(() => _sortBy = 'name');
                        Navigator.pop(context);
                        _loadProducts();
                      },
                    ),
                    _SortOption(
                      label: 'Price: Low to High',
                      value: _sortBy == 'price_low',
                      onTap: () {
                        setState(() => _sortBy = 'price_low');
                        Navigator.pop(context);
                        _loadProducts();
                      },
                    ),
                    _SortOption(
                      label: 'Price: High to Low',
                      value: _sortBy == 'price_high',
                      onTap: () {
                        setState(() => _sortBy = 'price_high');
                        Navigator.pop(context);
                        _loadProducts();
                      },
                    ),
                    _SortOption(
                      label: 'Newest First',
                      value: _sortBy == 'newest',
                      onTap: () {
                        setState(() => _sortBy = 'newest');
                        Navigator.pop(context);
                        _loadProducts();
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
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
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
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

  const _SortOption({
    required this.label,
    required this.value,
    required this.onTap,
  });

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

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (product.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          _PlaceholderImage(product: product),
                    )
                  else
                    _PlaceholderImage(product: product),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.isMedicine
                            ? AppColors.accent
                            : AppColors.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.isMedicine ? 'Medicine' : 'Equipment',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (product.requiresVerification)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TZS ${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: product.stock > 0
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.stock > 0 ? 'In Stock' : 'Out',
                          style: TextStyle(
                            color: product.stock > 0
                                ? AppColors.success
                                : AppColors.error,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: product.stock > 0
                          ? () {
                              cartProvider.add(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} added to cart'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: Text(
                        product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
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
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: Icon(
          product.isMedicine ? Icons.medication : Icons.medical_services,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
