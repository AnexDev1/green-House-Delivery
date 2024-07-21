import 'package:flutter/material.dart';

import '../../models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.product.category,
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              centerTitle: true,
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ))
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          Text(
                            '${widget.product.rating} (653 Reviews)',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Increased space
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${widget.product.price.toStringAsFixed(2)} Birr',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon:
                                  const Icon(Icons.remove, color: Colors.black),
                              onPressed: decrementQuantity,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('$quantity'),
                          const SizedBox(width: 10),
                          Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: const Icon(Icons.add, color: Colors.black),
                              onPressed: incrementQuantity,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20), // Increased space
                  Text(
                    'About ${widget.product.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), // Increased space
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20), // Increased space
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Add your add to cart functionality here
                    },
                    child: const Text('Add to Cart'),
                  ),
                  // Add more product details here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
