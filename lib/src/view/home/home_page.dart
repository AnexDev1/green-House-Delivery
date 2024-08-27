import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/product.dart';
import 'package:greenhouse/src/view/home/view/carousel.dart';
import 'package:greenhouse/src/view/home/view/category_tab.dart';
import 'package:greenhouse/src/view/home/view/searchbar.dart';
import 'package:greenhouse/src/view/home/view/user_avatar.dart';
import 'package:greenhouse/src/view/product/view/product_list.dart';
import 'package:provider/provider.dart';

import '../../providers/productProvider.dart';
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
  String username = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadUsername().then((loadedUsername) {
      setState(() {
        username = loadedUsername;
      });
    });
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        Provider.of<ProductProvider>(context, listen: false)
            .setCategory(getCurrentCategory(_tabController.index));
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final firstName = username.split(" ")[0];

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
                  Column(
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
                  ),
                  const UserAvatar(
                    imageUrl:
                        'https://randomuser.me/api/portraits/women/91.jpg',
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
                                allProducts: Provider.of<ProductProvider>(
                                        context,
                                        listen: false)
                                    .filteredProducts,
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
                  child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      return FutureBuilder<List<Product>>(
                        future: productProvider.productsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return ProductList(
                                filteredProducts:
                                    productProvider.filteredProducts);
                          } else {
                            return Text('No products found');
                          }
                        },
                      );
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
