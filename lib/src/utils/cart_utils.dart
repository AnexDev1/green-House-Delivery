import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/product.dart';
import 'package:greenhouse/src/providers/cartProvider.dart';
import 'package:provider/provider.dart';

class CartUtils {
  static void addToCart(BuildContext context, Product product,
      [int quantity = 1]) {
    // Add to cart logic here
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    for (int i = 0; i < quantity; i++) {
      cartProvider.addProduct(product);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${product.name} added to cart"),
        duration: const Duration(seconds: 2)));
  }
}
