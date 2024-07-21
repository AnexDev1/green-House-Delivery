class CartItem {
  final String name;
  final double price;
  int _quantity;
  final String imageUrl;

  CartItem(
      {required this.name,
      required this.price,
      required int quantity,
      required this.imageUrl})
      : _quantity = quantity;

  int get quantity => _quantity;

  set quantity(int newQuantity) {
    _quantity = newQuantity;
  }
}
