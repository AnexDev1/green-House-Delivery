import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Hero(
              tag:
                  'product-hero-${product.id}', // Ensure this tag is unique for each product
              child: Image.network(product.imageUrl,
                  height: 135, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, size: 14),
                        onPressed: () => onTap(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.yellow),
                      const SizedBox(width: 5),
                      Text('${product.rating}',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
