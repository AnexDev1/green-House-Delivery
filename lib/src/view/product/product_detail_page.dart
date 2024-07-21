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
                  bottomLeft:
                      Radius.circular(20.0), // Adjust the radius as needed
                  bottomRight:
                      Radius.circular(20.0), // Adjust the radius as needed
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              // Text(
              //   widget.product.category,
              //   style: const TextStyle(fontSize: 16.0, color: Colors.white),
              // ),
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
                  const SizedBox(height: 2),
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
                            alignment: Alignment.center, // Center the icon
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey), // Outline color
                              borderRadius: BorderRadius.circular(
                                  4), // More square-like corners
                            ),
                            child: IconButton(
                              padding: EdgeInsets
                                  .zero, // Remove padding to allow the icon to center
                              iconSize: 20, // Adjust the icon size as needed
                              icon:
                                  const Icon(Icons.remove, color: Colors.black),
                              onPressed: decrementQuantity,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('$quantity'),
                          SizedBox(width: 10),
                          Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center, // Center the icon
                            decoration: BoxDecoration(
                              color: Colors
                                  .amber, // Amber background color for the add icon
                              border: Border.all(
                                  color: Colors
                                      .amber), // Outline color matches background
                              borderRadius: BorderRadius.circular(
                                  4), // More square-like corners
                            ),
                            child: IconButton(
                              padding: EdgeInsets
                                  .zero, // Remove padding to allow the icon to center
                              iconSize: 20, // Adjust the icon size as needed
                              icon: const Icon(Icons.add, color: Colors.black),
                              onPressed: incrementQuantity,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'About ${widget.product.name}',
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'lorem ipsum dolor sit amet ipsum dolor sit ametipsum dolor sit ametipsum dolor sit ametipsum dolor sit ametipsum dolor sit ametipsum dolor sit amet',
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: const Size(
                          double.infinity, 50), // Full width and 50 height
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
