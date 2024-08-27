import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/cart/view/cart_item.dart';
import 'package:greenhouse/src/view/cart/view/total_price_section.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../../providers/cartProvider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final List<CartItem> cartItems = cartProvider.items;
          const double deliveryFee = 20.0;
          final double itemsTotalPrice = cartItems.fold(0,
              (total, current) => total + (current.price * current.quantity));
          final double totalAmount = itemsTotalPrice + deliveryFee;

          return Column(
            children: [
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(child: Text('No items in cart'))
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 7.0,
                            ),
                            child: CartItemWidget(
                              item: item,
                              onRemove: () {
                                cartProvider.removeProduct(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${item.name} removed from cart'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
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
                  totalPrice: itemsTotalPrice,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
