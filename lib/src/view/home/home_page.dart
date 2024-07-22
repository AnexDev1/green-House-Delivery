import 'package:flutter/material.dart';
import 'package:greenhouse/src/widgets/carousel.dart';
import 'package:greenhouse/src/widgets/product_card.dart';

import '../../models/product.dart';
import '../product/product_detail_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Product> filteredProducts = [];
  final List<String> imgList = [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg',
    // Add more image URLs as needed
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_updateFilteredProducts);
    _updateFilteredProducts(); // Initial update
  }

  void _updateFilteredProducts() {
    if (_tabController.indexIsChanging) return;

    setState(() {
      String selectedCategory = _tabController.index == 0
          ? 'Popular'
          : _tabController.index == 1
              ? 'Pizza'
              : _tabController.index == 2
                  ? 'Burger'
                  : 'Drinks';
      if (selectedCategory == 'Popular') {
        // Filter products that are popular
        filteredProducts =
            productList.where((product) => product.isPopular).toList();
      } else {
        // For other categories, filter by category name
        // Assuming you want to show popular items in these categories, add && product.isPopular if needed
        filteredProducts = productList
            .where((product) =>
                product.category.toLowerCase() ==
                selectedCategory.toLowerCase())
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              TabBar(
                dividerHeight: 0,
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: const [
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
                  child: filteredProducts.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredProducts
                              .length, // Assume productList is a list of Product objects
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
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
                                  )),
                            );
                          },
                          padding: const EdgeInsets.only(bottom: 5),
                        )
                      : const Center(
                          child: Text('No products found'),
                        )
                  // T
                  ) // he rest of your body content goes here
            ],
          ),
        ),
      ),
    );
  }
}
