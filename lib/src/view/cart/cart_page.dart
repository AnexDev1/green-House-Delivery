import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../../providers/cartProvider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    // This is moved to initState to ensure it's only called once when the widget is inserted into the widget tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      setState(() {
        cartItems = cartProvider.items;
      });
    });
  }

  double get totalPrice => cartItems.fold(
      0, (total, current) => total + (current.price * current.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Column(
                  children: [
                    Stack(
                      children: [
                        ListTile(
                          tileColor: Colors.grey[400],
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                item.imageUrl), // Display the image
                            radius: 30, // Adjust the size as needed
                          ),
                          title: Text(item.name),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Text('\$${item.price}'),
                        ),
                        Positioned(
                          top: -8,
                          right: -3,
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                size: 18, color: Colors.black),
                            onPressed: () {
                              // Call method to remove item from cart
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeProduct(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${item.name} removed from cart'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              // Update the state to reflect the change
                              setState(() {
                                cartItems = Provider.of<CartProvider>(context,
                                        listen: false)
                                    .items;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Adjust the height as needed
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${totalPrice.toStringAsFixed(2)} Birr',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    // Implement your payment logic here
                    print('Proceeding to payment');
                  },
                  child: const Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
