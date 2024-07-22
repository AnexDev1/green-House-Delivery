import 'package:flutter/material.dart';
import 'package:greenhouse/src/widgets/carousel.dart';
import 'package:greenhouse/src/widgets/category_tab.dart';
import 'package:greenhouse/src/widgets/product_list.dart';
import 'package:greenhouse/src/widgets/recommended_section.dart';
import 'package:greenhouse/src/widgets/searchbar.dart';

import '../../models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String getCurrentCategory() {
    if (_tabController.index == 0) {
      return 'Popular'; // This indicates the popular tab is selected
    } else {
      // Return the category name based on the selected tab
      switch (_tabController.index) {
        case 1:
          return 'Pizza';
        case 2:
          return 'Burger';
        case 3:
          return 'Drinks';
        default:
          return 'Popular'; // Fallback, should not be reached
      }
    }
  }

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
      String selectedCategory = getCurrentCategory();
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
              padding: EdgeInsets.symmetric(horizontal: 20.0),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SearchBarWidget(),
                const VerticalImageCarousel(),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Category', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                CategoryTabBar(controller: _tabController),
                RecommendedSection(
                  currentCategory: getCurrentCategory(),
                  filteredProducts: filteredProducts,
                ),
                ProductList(
                    filteredProducts:
                        filteredProducts) // he rest of your body content goes here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
