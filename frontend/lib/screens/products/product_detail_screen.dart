import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../utils/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: widget.product.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.product.imageUrl!,
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: Icon(
                        widget.product.isMedicine
                            ? Icons.medication
                            : Icons.medical_services,
                        size: 100,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.product.isMedicine
                              ? AppColors.accent
                              : AppColors.secondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.product.isMedicine ? 'Medicine' : 'Equipment',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'TZS ${widget.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            size: 18,
                            color: widget.product.stock > 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.product.stock > 0
                                ? '${widget.product.stock} in stock'
                                : 'Out of Stock',
                            style: TextStyle(
                              color: widget.product.stock > 0
                                  ? AppColors.success
                                  : AppColors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (widget.product.stock > 0) ...[
                    Text(
                      'Quantity',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                            color: AppColors.primary,
                          ),
                          Container(
                            width: 50,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                vertical: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              '$_quantity',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _quantity < widget.product.stock
                                ? () => setState(() => _quantity++)
                                : null,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: widget.product.stock > 0
                ? () {
                    cartProvider.add(widget.product, quantity: _quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.name} added to cart'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Add to Cart - TZS ${(widget.product.price * _quantity).toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
