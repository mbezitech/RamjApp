import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../screens/products/product_list_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(Icons.storefront, 'Products', currentIndex == 0, () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const ProductListScreen()),
                  (route) => false,
                );
              }),
              _navItem(Icons.receipt_long, 'Orders', currentIndex == 1, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                );
              }),
              _navItem(Icons.person, 'Profile', currentIndex == 2, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isActive ? AppColors.onPrimaryContainer : AppColors.secondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelMd.copyWith(
                color: isActive ? AppColors.onPrimaryContainer : AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
