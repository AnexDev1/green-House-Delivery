import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/product.dart';
import 'package:greenhouse/src/services/firebase_database_service.dart';
import 'package:greenhouse/src/view/home/view/carousel.dart';
import 'package:greenhouse/src/view/home/view/category_tab.dart';
import 'package:greenhouse/src/view/home/view/searchbar.dart';
import 'package:greenhouse/src/view/home/view/user_avatar.dart';
import 'package:greenhouse/src/view/product/view/product_list.dart';

import '../../utils/payment_utls.dart';
import '../../utils/product_filter.dart';
import '../product/product_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Product>> _productsFuture;
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _productsFuture = FirebaseDatabaseService().fetchProducts();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _updateFilteredProducts();
      }
    });
    _updateFilteredProducts(); // Initial update
  }

  void _updateFilteredProducts() async {
    final products = await _productsFuture;
    setState(() {
      String selectedCategory = getCurrentCategory(_tabController.index);
      _filteredProducts = filterProducts(products, selectedCategory);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<String>(
                    stream: loadUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Hello, Loading...',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Hello, Error',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      } else {
                        final firstName =
                            snapshot.data?.split(" ")[0] ?? 'User';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Hello, $firstName',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text('Welcome back',
                                style: TextStyle(fontSize: 16)),
                          ],
                        );
                      }
                    },
                  ),
                  const UserAvatar(
                    imageUrl: 'https://randomuser.me/api/portraits/lego/4.jpg',
                  ),
                ],
              ),
            ),
            titleSpacing: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SearchBarWidget(),
                const VerticalImageCarousel(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recommended For You',
                          style: TextStyle(fontSize: 20)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListPage(
                                allProducts: _filteredProducts,
                                category:
                                    getCurrentCategory(_tabController.index),
                              ),
                            ),
                          );
                        },
                        child: Text('See All',
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                      ),
                    ],
                  ),
                ),
                CategoryTabBar(controller: _tabController),
                SizedBox(
                  height: 270,
                  child: FutureBuilder<List<Product>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
                          child: ProductList(
                            key: ValueKey<int>(_tabController.index),
                            filteredProducts: _filteredProducts,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
