import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../models/rating_review.dart';
import '../../utils/cart_utils.dart';
import '../rating_review_form.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  bool isFav = false;
  final DatabaseReference reviewsRef =
      FirebaseDatabase.instance.ref().child('reviews');
  double averageRating = 0.0;
  int totalReviews = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  void toggleFavorite() {
    setState(() {
      isFav = !isFav;
    });
  }

  void _addReview(RatingReview review) async {
    try {
      await reviewsRef.push().set(review.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add review: $e')),
      );
    }
  }

  void _calculateAverageRating(List<RatingReview> reviews) {
    if (reviews.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          averageRating = 0.0;
          totalReviews = 0;
        });
      });
      return;
    }
    double sum = reviews.fold(0, (sum, review) => sum + review.rating);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        averageRating = sum / reviews.length;
        totalReviews = reviews.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.product.category,
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              centerTitle: true,
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () => toggleFavorite(),
                  icon: isFav
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        )),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 18, color: Color(0xff3fb31e)),
                          Text(
                            '$averageRating ($totalReviews Reviews)',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
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
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: Icon(Icons.remove,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                              onPressed: decrementQuantity,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('$quantity'),
                          const SizedBox(width: 10),
                          Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xff3fb31e),
                              border: Border.all(color: Color(0xff3fb31e)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: incrementQuantity,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'About ${widget.product.name}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                    'sed do eiusmod tempor incididunt ut labore et dolore'
                    ' magna aliqua.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff3fb31e),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () => {
                      CartUtils.addToCart(context, widget.product, quantity),
                      setState(() {
                        quantity = 1;
                      }),
                    },
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RatingReviewForm(
                    onSubmit: _addReview,
                    product: widget.product,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder(
                    stream: reviewsRef.onValue,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.data!.snapshot.value == null) {
                        return Text('No reviews available');
                      }
                      final Map<dynamic, dynamic>? reviewsMap = snapshot
                          .data!.snapshot.value as Map<dynamic, dynamic>?;
                      if (reviewsMap == null || reviewsMap.isEmpty) {
                        return Text('No reviews available');
                      }
                      final reviews = reviewsMap.values
                          .map((e) => RatingReview.fromMap(
                              Map<String, dynamic>.from(e)))
                          .where(
                              (review) => review.productId == widget.product.id)
                          .toList();
                      _calculateAverageRating(reviews);
                      return ListView.builder(
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
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
