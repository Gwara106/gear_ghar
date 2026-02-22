import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class CartItem {
  final Map<String, dynamic> product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'quantity': quantity,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        MapEquality().equals(product, other.product);
  }

  @override
  int get hashCode => product.hashCode;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      final priceString = item.product['price'].toString().replaceAll('Rs. ', '').replaceAll(',', '');
      final price = double.tryParse(priceString) ?? 0.0;
      total += price * item.quantity;
    }
    return total;
  }

  void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => MapEquality().equals(item.product, product),
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _cartItems.removeWhere(
      (item) => MapEquality().equals(item.product, product),
    );
    notifyListeners();
  }

  void updateQuantity(Map<String, dynamic> product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }

    final existingItemIndex = _cartItems.indexWhere(
      (item) => MapEquality().equals(item.product, product),
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(Map<String, dynamic> product) {
    return _cartItems.any(
      (item) => MapEquality().equals(item.product, product),
    );
  }

  int getQuantity(Map<String, dynamic> product) {
    final item = _cartItems.firstWhere(
      (item) => MapEquality().equals(item.product, product),
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }
}
