import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/cart/view/cart_item.dart';
import 'package:greenhouse/src/view/cart/view/total_price_section.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../../providers/cartProvider.dart';

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
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    setState(() {
      cartItems = cartProvider.items;
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
                if (cartItems.isEmpty) {
                  return const Center(
                    child: Text('No items in cart'),
                  );
                }
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
            child: TotalPriceSection(
                cartItems: cartItems,
                itemsTotalPrice: itemsTotalPrice,
                deliveryFee: deliveryFee,
                totalAmount: totalAmount,
                totalPrice: totalPrice),
          ),
        ],
      ),
    );
  }
}
