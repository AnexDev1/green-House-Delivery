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
    name: "Green Special",
    rating: 4.5,
    price: 349.99,
    category: "burger",
    isPopular: true,
  ),
  Product(
      imageUrl:
          "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
      name: "Chicken Pizza",
      rating: 4.0,
      price: 439.99,
      category: "Pizza",
      isPopular: true),
  Product(
    imageUrl:
        "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Jumbo Special",
    rating: 5.0,
    price: 549.99,
    category: "Burger",
    isPopular: true,
  ),
  Product(
    imageUrl:
        "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Coke",
    rating: 3.5,
    price: 14.99,
    category: "Drinks",
    isPopular: true,
  ),
  // Add more products as needed
];
