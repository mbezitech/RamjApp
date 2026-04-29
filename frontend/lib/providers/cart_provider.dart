import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  double get total {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  void add(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void increment(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrement(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        remove(productId);
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> toOrderItems() {
    return _items.map((item) {
      return {
        'product_id': item.product.id,
        'quantity': item.quantity,
      };
    }).toList();
  }
}
