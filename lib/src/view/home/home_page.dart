import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/product.dart';
import 'package:greenhouse/src/services/firebase_database_service.dart';
import 'package:greenhouse/src/view/home/view/carousel.dart';
import 'package:greenhouse/src/view/home/view/category_tab.dart';
import 'package:greenhouse/src/view/home/view/recommended_section.dart';
import 'package:greenhouse/src/view/home/view/searchbar.dart';
import 'package:greenhouse/src/widgets/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String username = 'Loading...';

  Future<String> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ??
        'User'; // Default to 'User' if not found
  }

  @override
  void initState() {
    super.initState();
    _loadUsername().then((loadedUsername) {
      setState(() {
        username = loadedUsername;
      });
    });
    _tabController = TabController(length: 4, vsync: this);
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
      String selectedCategory = getCurrentCategory();
      if (selectedCategory == 'Popular') {
        _filteredProducts =
            products.where((product) => product.isPopular).toList();
      } else {
        _filteredProducts = products
            .where((product) =>
                product.category.toLowerCase() ==
                selectedCategory.toLowerCase())
            .toList();
      }
    });
  }

  String getCurrentCategory() {
    if (_tabController.index == 0) {
      return 'Popular';
    } else {
      switch (_tabController.index) {
        case 1:
          return 'Pizza';
        case 2:
          return 'Burger';
        case 3:
          return 'Drinks';
        default:
          return 'Popular';
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = username.split(" ")[0];
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Use a FutureBuilder as shown in the ProfilePage example
                      Text(
                        'Hello, $firstName', // Customize this text as needed
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      const Text('Welcome back',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 18.0,
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/women/93.jpg'),
                    backgroundColor: Colors.transparent,
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
                FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading..');
                    } else if (snapshot.hasError) {
                      return const Text('Error fetching products');
                    } else {
                      _filteredProducts = snapshot.data ?? [];
                      return RecommendedSection(
                        currentCategory: getCurrentCategory(),
                        filteredProducts: _filteredProducts,
                      );
                    }
                  },
                ),
                ProductList(filteredProducts: _filteredProducts),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
