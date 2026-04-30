import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

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
  bool _isSearching = false;
  String? _error;
  String _statusFilter = 'all';
  String _paymentFilter = 'all';
  String _sortBy = 'newest';
  String _searchQuery = '';

  final List<Map<String, String>> _statuses = [
    {'value': 'all', 'label': 'All'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'processing', 'label': 'Processing'},
    {'value': 'shipped', 'label': 'Shipped'},
    {'value': 'delivered', 'label': 'Delivered'},
    {'value': 'cancelled', 'label': 'Cancelled'},
  ];

  final List<Map<String, String>> _paymentStatuses = [
    {'value': 'all', 'label': 'All'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'paid', 'label': 'Paid'},
    {'value': 'failed', 'label': 'Failed'},
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
    setState(() {
      _isLoading = true;
      _error = null;
      _isSearching = true;
    });

    try {
      final queryParams = <String, String>{
        'status': _statusFilter,
        'payment_status': _paymentFilter,
        'sort': _sortBy,
      };
      if (_searchQuery.isNotEmpty) {
        queryParams['search'] = _searchQuery;
      }

      final response = await _apiService.get('/orders', queryParams: queryParams);

      setState(() {
        final ordersList = response['orders'];
        if (ordersList is List) {
          _orders = ordersList.map((o) => Order.fromJson(o)).toList();
        } else {
          _orders = [];
          _error = 'Invalid response format';
        }
        _isLoading = false;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('ApiException: ', '');
        _isLoading = false;
        _isSearching = false;
        _orders = [];
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return AppColors.warning;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPaymentColor(String status) {
    switch (status) {
      case 'paid':
        return AppColors.success;
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = _statusFilter != 'all' || _paymentFilter != 'all' || _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: hasActiveFilters ? Colors.yellow : Colors.white),
            tooltip: 'Filters',
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search orders...',
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
          if (hasActiveFilters || _isSearching)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                children: [
                  Text(
                    _isLoading ? 'Loading...' : '${_orders.length} order${_orders.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (_statusFilter != 'all')
                    _FilterBadge(
                      label: _statuses.firstWhere((s) => s['value'] == _statusFilter)['label']!,
                      onRemove: () => setState(() => _statusFilter = 'all'),
                    ),
                  if (_paymentFilter != 'all')
                    _FilterBadge(
                      label: _paymentStatuses.firstWhere((s) => s['value'] == _paymentFilter)['label']!,
                      onRemove: () => setState(() => _paymentFilter = 'all'),
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
                              onPressed: _loadOrders,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _orders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  hasActiveFilters ? Icons.filter_list_off : Icons.receipt_long,
                                  size: 64,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  hasActiveFilters
                                      ? 'No orders match filters'
                                      : 'No orders yet',
                                  style: TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (hasActiveFilters) ...[
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _statusFilter = 'all';
                                        _paymentFilter = 'all';
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
                          )
                        : RefreshIndicator(
                            onRefresh: _loadOrders,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _orders.length,
                              itemBuilder: (context, index) {
                                final order = _orders[index];
                                return _OrderCard(
                                  order: order,
                                  statusColor: _getStatusColor(order.status),
                                  statusLabel: _getStatusLabel(order.status),
                                  paymentColor: _getPaymentColor(order.paymentStatus),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    return status.toUpperCase().replaceAll('_', ' ');
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
                            _statusFilter = 'all';
                            _paymentFilter = 'all';
                            _sortBy = 'newest';
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Order Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _statuses.map((s) {
                      final selected = _statusFilter == s['value'];
                      return ChoiceChip(
                        label: Text(s['label']!),
                        selected: selected,
                        selectedColor: s['value'] == 'all'
                            ? AppColors.primary.withOpacity(0.2)
                            : _getStatusColor(s['value']!).withOpacity(0.2),
                        checkmarkColor: _getStatusColor(s['value'] == 'all' ? 'pending' : s['value']!),
                        onSelected: (_) {
                          setModalState(() => _statusFilter = s['value']!);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Payment Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _paymentStatuses.map((s) {
                      final selected = _paymentFilter == s['value'];
                      return ChoiceChip(
                        label: Text(s['label']!),
                        selected: selected,
                        selectedColor: _getPaymentColor(s['value'] == 'all' ? 'pending' : s['value']!).withOpacity(0.2),
                        onSelected: (_) {
                          setModalState(() => _paymentFilter = s['value']!);
                        },
                      );
                    }).toList(),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Sort By',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _SortOption(
                    label: 'Newest First',
                    value: _sortBy == 'newest',
                    onTap: () => setModalState(() => _sortBy = 'newest'),
                  ),
                  _SortOption(
                    label: 'Oldest First',
                    value: _sortBy == 'oldest',
                    onTap: () => setModalState(() => _sortBy = 'oldest'),
                  ),
                  _SortOption(
                    label: 'Price: High to Low',
                    value: _sortBy == 'price_high',
                    onTap: () => setModalState(() => _sortBy = 'price_high'),
                  ),
                  _SortOption(
                    label: 'Price: Low to High',
                    value: _sortBy == 'price_low',
                    onTap: () => setModalState(() => _sortBy = 'price_low'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                        _loadOrders();
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

class _OrderCard extends StatelessWidget {
  final Order order;
  final Color statusColor;
  final String statusLabel;
  final Color paymentColor;

  const _OrderCard({
    required this.order,
    required this.statusColor,
    required this.statusLabel,
    required this.paymentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.15),
          child: Icon(Icons.shopping_bag, color: statusColor, size: 20),
        ),
        title: Text(
          order.orderNumber,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TZS ${order.totalAmount.toStringAsFixed(0)}',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                  style: TextStyle(color: AppColors.textLight, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: paymentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.paymentStatus.toUpperCase(),
                    style: TextStyle(
                      color: paymentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: ${item.quantity} × TZS ${item.unitPrice.toStringAsFixed(0)}',
                                  style: TextStyle(color: AppColors.textLight, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'TZS ${item.subtotal.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      'TZS ${order.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.shippingAddress,
                        style: TextStyle(color: AppColors.textLight, fontSize: 12),
                      ),
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
}
