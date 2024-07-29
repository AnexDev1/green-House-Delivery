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
      labelColor: Color(0xff3fb31e),
      indicatorColor: Color(0xff3fb31e),
      isScrollable: true,
      tabs: const [
        Tab(text: 'Popular'),
        Tab(text: 'Breakfast'),
        Tab(text: 'Burger'),
        Tab(text: 'Sandwiches'),
        Tab(text: 'Juice'),
        Tab(text: 'Drinks'),
      ],
    );
  }
}
