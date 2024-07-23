import 'package:flutter/material.dart';

class CategoryTabBar extends StatelessWidget {
  final TabController controller;
  const CategoryTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerHeight: 0,
      tabAlignment: TabAlignment.start,
      controller: controller,
      labelColor: Colors.amber[600],
      indicatorColor: Colors.amber[600],
      isScrollable: true,
      tabs: const [
        Tab(text: 'Popular'),
        Tab(text: 'Pizza'),
        Tab(text: 'Burger'),
        Tab(text: 'Drinks'),
      ],
    );
  }
}
