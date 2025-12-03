import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);
  
  double get totalPrice => _items.fold(0.0, (total, item) => total + item.totalPrice);

  void addToCart(Product product) {
    final existingItemIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingItemIndex != -1) {
      _items[existingItemIndex] = _items[existingItemIndex].copyWith(
        quantity: _items[existingItemIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = _items.indexWhere((item) => item.product.id == productId);
    if (itemIndex != -1) {
      _items[itemIndex] = _items[itemIndex].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}