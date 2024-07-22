import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/product.dart';

import '../../product/product_list_page.dart';

class RecommendedSection extends StatelessWidget {
  final String currentCategory;
  final List<Product> filteredProducts;
  const RecommendedSection({
    Key? key,
    required this.currentCategory,
    required this.filteredProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Recommended For You', style: TextStyle(fontSize: 20)),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductListPage(
                    category: currentCategory,
                    allProducts: filteredProducts,
                  ),
                ),
              );
            },
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }
}
