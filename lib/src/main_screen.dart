import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/cart/cart_page.dart';
import 'package:greenhouse/src/view/home/home_page.dart';
import 'package:greenhouse/src/view/order/order_history_page.dart';
import 'package:greenhouse/src/view/profile/profile_page.dart';
import 'package:greenhouse/src/view/search/search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of widgets to display in the body of Scaffold, based on the selected index
  final List<Widget> _widgetOptions = [
    HomePage(),
    const CartPage(),
    OrderHistoryPage(),
    SearchPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_sharp),
            label: 'Profile',
          ),

          // Add other items for your pages here
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xff3fb31e),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
