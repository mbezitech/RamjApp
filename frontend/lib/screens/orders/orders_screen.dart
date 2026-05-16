import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bottom_nav.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ApiService _apiService = ApiService();
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;
  String _statusFilter = 'all';
  String _searchQuery = '';

  final List<Map<String, String>> _statuses = [
    {'value': 'all', 'label': 'All'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'shipped', 'label': 'Shipped'},
    {'value': 'delivered', 'label': 'Delivered'},
    {'value': 'cancelled', 'label': 'Cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
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
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final queryParams = <String, String>{
        'status': _statusFilter,
      };
      if (_searchQuery.isNotEmpty) {
        queryParams['search'] = _searchQuery;
      }

      final response = await _apiService.get('/orders', queryParams: queryParams);
      if (!mounted) return;

      final ordersData = response['orders'];
      if (ordersData == null || ordersData is! List) {
        setState(() {
          _error = 'Invalid response';
          _orders = [];
          _isLoading = false;
        });
        return;
      }

      final parsedOrders = <Order>[];
      for (final o in ordersData) {
        try {
          parsedOrders.add(Order.fromJson(o as Map<String, dynamic>));
        } catch (_) {}
      }

      setState(() {
        _orders = parsedOrders;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _error != null
                    ? _buildError()
                    : _orders.isEmpty
                        ? _buildEmpty()
                        : _buildOrderList(),
          ),
          const AppBottomNav(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceVariant),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
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
                  'Orders',
                  style: AppTypography.h3.copyWith(color: AppColors.primary),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.settings, color: AppColors.primary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: _buildSearchBar(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12),
            child: _buildFilterChips(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: AppTypography.bodyMd,
        decoration: InputDecoration(
          hintText: 'Search by Order ID or product name...',
          hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.secondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _statuses.map((status) {
          final isSelected = _statusFilter == status['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _statusFilter = status['value']!);
                _loadOrders();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status['label']!,
                  style: AppTypography.labelMd.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderList() {
    final filteredOrders = _statusFilter == 'all'
        ? _orders
        : _orders.where((o) => o.status == _statusFilter).toList();

    if (filteredOrders.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _OrderCard(order: filteredOrders[index]),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final hasFiltersOrSearch = _statusFilter != 'all' || _searchQuery.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFiltersOrSearch ? Icons.filter_list_off : Icons.receipt_long,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              hasFiltersOrSearch ? 'No orders match filters' : 'No orders yet',
              style: AppTypography.bodyMd.copyWith(color: AppColors.textLight),
            ),
            if (hasFiltersOrSearch) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _statusFilter = 'all';
                    _searchQuery = '';
                    _searchController.clear();
                  });
                  _loadOrders();
                },
                child: const Text('Clear filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
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
              onPressed: _loadOrders,
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

}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  String _getStatusLabel() {
    switch (order.status) {
      case 'pending':
        return 'Pending';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return order.status;
    }
  }

  Color _getBadgeBg() {
    switch (order.status) {
      case 'pending':
        return AppColors.primaryFixed;
      case 'shipped':
        return AppColors.secondaryContainer;
      case 'cancelled':
        return AppColors.surfaceVariant;
      default:
        return AppColors.surfaceContainerHigh;
    }
  }

  Color _getBadgeText() {
    switch (order.status) {
      case 'pending':
        return AppColors.primary;
      case 'shipped':
        return AppColors.onSecondaryContainer;
      default:
        return AppColors.secondary;
    }
  }

  String _getActionLabel() {
    switch (order.status) {
      case 'delivered':
        return 'Reorder';
      case 'cancelled':
        return 'View Details';
      default:
        return 'Track Order';
    }
  }

  bool _isActionEnabled() {
    return order.status != 'cancelled';
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} • $hour:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.status == 'cancelled';
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final remainingCount = order.items.length - 1;

    return Opacity(
      opacity: isCancelled ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border.all(color: AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                          order.orderNumber.toUpperCase(),
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(order.createdAt),
                          style: AppTypography.bodySm.copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getBadgeBg(),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _getStatusLabel(),
                      style: AppTypography.labelBold.copyWith(color: _getBadgeText()),
                    ),
                  ),
                ],
              ),
              if (firstItem != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.surfaceVariant),
                      bottom: BorderSide(color: AppColors.surfaceVariant),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: firstItem.product.imageUrl != null
                              ? Image.network(
                                  firstItem.product.imageUrl!,
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
                              children: [
                                Flexible(
                                  child: Text(
                                    firstItem.product.name,
                                    style: AppTypography.labelBold.copyWith(color: AppColors.onSurface),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (remainingCount > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '+$remainingCount',
                                      style: AppTypography.labelBold.copyWith(
                                        color: AppColors.onPrimary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantity: ${firstItem.quantity} Unit${firstItem.quantity > 1 ? 's' : ''}',
                              style: AppTypography.bodySm.copyWith(color: AppColors.secondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: AppTypography.bodySm.copyWith(color: AppColors.secondary),
                  ),
                  Text(
                    'TZS ${order.totalAmount.toStringAsFixed(2)}',
                    style: AppTypography.h3.copyWith(
                      color: isCancelled ? AppColors.secondary : AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isActionEnabled()
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OrderDetailScreen(order: order),
                            ),
                          );
                        }
                      : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.surfaceContainerLow,
                    foregroundColor: isCancelled ? AppColors.secondary : AppColors.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.outlineVariant),
                    ),
                    disabledBackgroundColor: AppColors.surfaceContainerLow,
                    disabledForegroundColor: AppColors.secondary,
                  ),
                  child: Text(
                    _getActionLabel(),
                    style: AppTypography.labelBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.medical_services,
        size: 28,
        color: AppColors.primary.withOpacity(0.3),
      ),
    );
  }
}
