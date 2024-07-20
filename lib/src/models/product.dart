class Product {
  final String imageUrl;
  final String name;
  final double rating;
  final double price;
  final String category;
   String id;

  Product({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    required this.category,
    String? id,
  }): id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

// Mockup for the productList
List<Product> productList = [
  Product(

    imageUrl: "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Product 1",
    rating: 4.5,
    price: 19.99,
    category: "Popular",
  ),
  Product(
    imageUrl: "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Product 2",
    rating: 4.0,
    price: 29.99,
    category: "Pizza",
  ),
  Product(
    imageUrl: "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Product 3",
    rating: 5.0,
    price: 9.99,
    category: "Burger",
  ),
  Product(
    imageUrl: "https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg",
    name: "Product 4",
    rating: 3.5,
    price: 14.99,
    category: "Drinks",
  ),
  // Add more products as needed
];