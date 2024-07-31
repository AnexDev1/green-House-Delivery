import 'package:greenhouse/src/models/product.dart';

String getCurrentCategory(int tabIndex) {
  if (tabIndex == 0) {
    return 'Popular';
  } else {
    switch (tabIndex) {
      case 1:
        return 'Breakfast';
      case 2:
        return 'Burger';
      case 3:
        return 'Sandwiches';
      case 4:
        return 'Juice';
      case 5:
        return 'Drinks';
      default:
        return 'Popular';
    }
  }
}

List<Product> filterProducts(List<Product> products, String selectedCategory) {
  if (selectedCategory == 'Popular') {
    return products.where((product) => product.isPopular).toList();
  } else {
    return products
        .where((product) =>
            product.category.toLowerCase() == selectedCategory.toLowerCase())
        .toList();
  }
}
