import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/product.dart';
import 'package:greenhouse/src/utils/cart_utils.dart';
import 'package:greenhouse/src/view/product/view/quantitySelector.dart';

import '../rating_review_form.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  double averageRating = 4.5; // Example value
  int totalReviews = 20; // Example value
  List reviews = []; // Example list of reviews

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addReview(review) {
    setState(() {
      reviews.add(review);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, size: 18, color: Color(0xff3fb31e)),
                Text(
                  '$averageRating ($totalReviews Reviews)',
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.product.price.toStringAsFixed(2)} Birr',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                QuantitySelector(
                  quantity: quantity,
                  incrementQuantity: incrementQuantity,
                  decrementQuantity: decrementQuantity,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'About ${widget.product.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
              'sed do eiusmod tempor incididunt ut labore et dolore'
              ' magna aliqua.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff3fb31e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                CartUtils.addToCart(context, widget.product, quantity);
                setState(() {
                  quantity = 1;
                });
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            RatingReviewForm(
              onSubmit: _addReview,
              product: widget.product,
            ),
            const SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  title: Text(review.user),
                  subtitle: Text(review.review),
                  trailing: Text(review.rating.toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
