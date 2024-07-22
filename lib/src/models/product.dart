class Product {
  final String id;
  final String imageUrl;
  final String name;
  final double rating;
  final double price;
  final String category;
  final bool isPopular;

  Product({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    required this.category,
    required this.isPopular,
  });

  factory Product.fromMap(Map<dynamic, dynamic> data) {
    return Product(
      id: data['id'],
      imageUrl: data['imageUrl'],
      name: data['name'],
      rating: data.containsKey('rating') ? data['rating'].toDouble() : 0.0,
      price: data['price'].toDouble(),
      category: data['category'],
      isPopular: data.containsKey('isPopular') ? data['isPopular'] : false,
    );
  }
}

// Mockup for the productList
