import 'package:flutter/material.dart';
import 'package:greenhouse/src/utils/cart_utils.dart';

import '../../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ThemeMode themeMode;

  const ProductCard(
      {super.key, required this.product, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeMode == ThemeMode.dark;
    return Card(
      elevation: 2,
      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Hero(
              tag: 'product-hero-${product.id}',
              child: Image.network(product.imageUrl,
                  height: 120, width: 170, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 15,
                        color: isDarkMode ? Colors.yellow : Color(0xff3fb31e),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                            fontSize: 15,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${product.price.toStringAsFixed(2)} Birr',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3fb31e)),
                  onPressed: () => CartUtils.addToCart(context, product),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_shopping_cart, color: Colors.white),
                      const SizedBox(width: 5),
                      const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
