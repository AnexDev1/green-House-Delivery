import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:greenhouse/src/widgets/carousel.dart';
import 'package:greenhouse/src/widgets/product_card.dart';

import '../../models/product.dart';
import '../product/product_detail_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> imgList = [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg',
    // Add more image URLs as needed
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Hello, Anwar',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight
                                .bold), // Adjusted for better fit in AppBar
                      ),
                      Text(
                        'Welcome back',
                        style: TextStyle(
                            fontSize: 16), // Adjusted for better fit in AppBar
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 18.0, // Adjusted for better fit in AppBar
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/women/93.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            titleSpacing: 0, // Reduces the default spacing
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Implement filter logic
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              const VerticalImageCarousel(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Category', style: TextStyle(fontSize: 20)),
                    TextButton(
                      onPressed: () {
                        // Implement See All logic
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              const TabBar(
                dividerHeight: 0,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Popular'),
                  Tab(text: 'Pizza'),
                  Tab(text: 'Burger'),
                  Tab(text: 'Drinks'),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recommended For You',
                        style: TextStyle(fontSize: 20)),
                    TextButton(
                      onPressed: () {
                        // Implement See All logic
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productList
                      .length, // Assume productList is a list of Product objects
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: product),
                              ),
                            );
                          },
                          child: ProductCard(
                            product: product,
                            onTap: () {},
                          )),
                    );
                  },
                  padding: const EdgeInsets.only(bottom: 5),
                ),
              ),
              // The rest of your body content goes here
            ],
          ),
        ),
      ),
    );
  }
}
