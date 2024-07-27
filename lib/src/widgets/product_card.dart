import 'package:flutter/material.dart';
import 'package:greenhouse/src/utils/cart_utils.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Hero(
              tag:
                  'product-hero-${product.id}', // Ensure this tag is unique for each product
              child: Image.network(product.imageUrl,
                  height: 80, width: 170, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Color(0xff3fb31e),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${product.price.toStringAsFixed(2)} Birr',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3fb31e)),
                  onPressed: () => CartUtils.addToCart(context, product),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
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
