import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/product.dart';
import 'package:greenhouse/src/services/firebase_database_service.dart';
import 'package:greenhouse/src/utils/product_filter.dart';

class ProductProvider with ChangeNotifier {
  late Future<List<Product>> _productsFuture;
  List<Product> _filteredProducts = [];
  String _selectedCategory = '';

  ProductProvider() {
    _productsFuture = FirebaseDatabaseService().fetchProducts();
    _updateFilteredProducts();
  }

  Future<List<Product>> get productsFuture => _productsFuture;
  List<Product> get filteredProducts => _filteredProducts;

  void setCategory(String category) {
    _selectedCategory = category;
    _updateFilteredProducts();
  }

  void _updateFilteredProducts() async {
    final products = await _productsFuture;
    _filteredProducts = filterProducts(products, _selectedCategory);
    notifyListeners();
  }
}
