class Product {
  final String imageUrl;
  final String name;
  final double rating;
  final double price;
  final String category;
  final bool isPopular;

  String id;

  Product({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    required this.category,
    required this.isPopular,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

// Mockup for the productList
List<Product> productList = [
  Product(
    imageUrl:
        "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Product 1",
    rating: 4.5,
    price: 19.99,
    category: "burger",
    isPopular: true,
  ),
  Product(
      imageUrl:
          "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
      name: "Product 2",
      rating: 4.0,
      price: 29.99,
      category: "Pizza",
      isPopular: true),
  Product(
    imageUrl:
        "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Product 3",
    rating: 5.0,
    price: 9.99,
    category: "Burger",
    isPopular: true,
  ),
  Product(
    imageUrl:
        "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Product 4",
    rating: 3.5,
    price: 14.99,
    category: "Drinks",
    isPopular: true,
  ),
  // Add more products as needed
];
