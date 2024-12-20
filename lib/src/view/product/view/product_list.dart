import 'package:flutter/material.dart';
import 'package:greenhouse/main.dart'; // Import the MyApp class
import 'package:greenhouse/src/models/product.dart';
import 'package:greenhouse/src/view/product/product_detail_page.dart';
import 'package:greenhouse/src/view/product/view/product_card.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.filteredProducts,
  });

  final List<Product> filteredProducts;

  @override
  Widget build(BuildContext context) {
    return filteredProducts.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
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
                      themeMode: MyApp.of(context).themeMode,
                    )),
              );
            },
            padding: const EdgeInsets.only(bottom: 5),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
