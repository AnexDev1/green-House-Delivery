import 'dart:async';

import 'package:flutter/material.dart';
import 'package:greenhouse/main.dart';

import '../../models/product.dart';
import '../../services/firebase_database_service.dart';
import '../product/view/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Product> _searchResults = [];
  Timer? _debounce;
  bool _hasStartedTyping = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _hasStartedTyping = true;
      });
    } else {
      setState(() {
        _hasStartedTyping = false;
        _searchResults = [];
      });
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (_searchController.text.isNotEmpty) {
        final results = await FirebaseDatabaseService()
            .searchProducts(_searchController.text);
        setState(() {
          _searchResults = results;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _hasStartedTyping
          ? (_searchResults.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults[index];
                    return ProductCard(
                      product: product,
                      themeMode: MyApp.of(context).themeMode,
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator()))
          : const Center(child: Text('Search for products')),
    );
  }
}
