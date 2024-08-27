import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/rating_review.dart';

class RatingReviewForm extends StatefulWidget {
  final Function(RatingReview) onSubmit;
  final Product product;

  RatingReviewForm({required this.onSubmit, required this.product});

  @override
  _RatingReviewFormState createState() => _RatingReviewFormState();
}

class _RatingReviewFormState extends State<RatingReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 0.0;
  bool _isAnonymous = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = _auth.currentUser?.email;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final review = RatingReview(
        user: _isAnonymous ? 'Anonymous' : (_userEmail ?? 'Unknown User'),
        rating: _rating,
        review: _reviewController.text,
        productId: widget.product.id,
      );
      widget.onSubmit(review);
      _reviewController.clear();
      setState(() {
        _rating = 0.0;
        _isAnonymous = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Text('Review as:'),
              Switch(
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
              ),
              Text(_isAnonymous ? 'Anonymous' : 'Email'),
            ],
          ),
          Text('Rate this product'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                ),
                color: Colors.amber,
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
              );
            }),
          ),
          TextFormField(
            controller: _reviewController,
            decoration: InputDecoration(labelText: 'Write a review'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a review';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
