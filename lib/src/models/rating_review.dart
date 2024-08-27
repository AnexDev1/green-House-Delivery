class RatingReview {
  final String user;
  final double rating;
  final String review;
  final String productId;

  RatingReview({
    required this.user,
    required this.rating,
    required this.review,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'rating': rating,
      'review': review,
      'productId': productId,
    };
  }

  factory RatingReview.fromMap(Map<String, dynamic> map) {
    return RatingReview(
      user: map['user'] ?? 'Unknown User',
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : (map['rating'] ?? 0.0),
      review: map['review'] ?? '',
      productId: map['productId'] ?? '',
    );
  }
}
