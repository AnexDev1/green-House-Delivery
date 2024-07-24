import 'dart:math';

import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/cart/view/cart_item.dart';
import 'package:greenhouse/src/view/order/payment_success.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../../providers/cartProvider.dart';

String generateTxRef(String prefix) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomSuffix = Random()
      .nextInt(9999)
      .toString()
      .padLeft(4, '0'); // Ensures a 4-digit random number
  return '$prefix-$timestamp-$randomSuffix';
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

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
    const double deliveryFee = 20.0;
    final double itemsTotalPrice =
        totalPrice; // Assuming totalPrice is calculated elsewhere in your code.
    final double totalAmount = itemsTotalPrice + deliveryFee;

    if (cartItems.isEmpty) {
      return const Center(
        child: Text('No items in cart'),
      );
    }
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

                return CartItemWidget(
                  item: item,
                  onRemove: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeProduct(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} removed from cart'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    setState(
                      () {
                        cartItems =
                            Provider.of<CartProvider>(context, listen: false)
                                .items;
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Item Total:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${itemsTotalPrice.toStringAsFixed(2)} birr',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Fee:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${deliveryFee.toStringAsFixed(2)} birr',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${totalAmount.toStringAsFixed(2)} Birr',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize:
                        const Size.fromHeight(50), // Set the button height
                  ),
                  onPressed: () async {
                    // Assuming totalPrice is calculated elsewhere in your code.
                    final double totalAmount =
                        totalPrice; // Use your totalPrice calculation logic here
                    String txRef = generateTxRef(
                        'green-house'); // Implement your transaction reference generator

                    await Chapa.getInstance.startPayment(
                      context: context,
                      amount: totalAmount.toString(),
                      currency: 'ETB',
                      txRef: txRef,
                      onInAppPaymentSuccess: (successMsg) {
                        // Handle successful payment here
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ThankYouPage(
                                txRef: txRef, amount: totalAmount.toString()),
                          ),
                        );
                        Provider.of<CartProvider>(context, listen: false)
                            .clearCart();
                        print("Payment Success: $successMsg");
                      },
                      onInAppPaymentError: (errorMsg) {
                        // Handle payment error here
                        print("Payment Error: $errorMsg");
                      },
                    );
                  },
                  child: const Text('Pay', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
