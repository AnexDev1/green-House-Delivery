import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/product/product_detail_page.dart';

import '../../models/product.dart';
import '../../widgets/product_card.dart';

class ProductListPage extends StatelessWidget {
  final String category;
  final List<Product> allProducts;

  const ProductListPage({
    super.key,
    required this.category,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts;
    if (category == 'Popular') {
      // Filter products for the "Popular" category
      filteredProducts =
          allProducts.where((product) => product.isPopular).toList();
    } else {
      // Filter products based on category name for other categories
      filteredProducts = allProducts
          .where((product) =>
              product.category.toLowerCase() == category.toLowerCase())
          .toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}
