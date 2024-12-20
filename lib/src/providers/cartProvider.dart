import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  late List<CartItem> _items = [];

  List<CartItem> get items => _items;
  void loadCart(List<CartItem> items) {
    _items = items;
    notifyListeners();
  }

  void addProduct(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.name == product.name);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(
          name: product.name,
          price: product.price,
          quantity: 1,
          imageUrl: product.imageUrl));
    }
    notifyListeners();
  }

  void removeProduct(CartItem item) {
    _items.removeWhere((cartItem) => cartItem.name == item.name);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
// Add other cart functionalities as needed
}
