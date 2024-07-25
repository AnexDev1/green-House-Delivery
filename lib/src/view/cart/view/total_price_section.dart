import 'dart:math';

import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cartProvider.dart';
import '../../order/payment_success.dart';

String generateTxRef(String prefix) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomSuffix = Random()
      .nextInt(9999)
      .toString()
      .padLeft(4, '0'); // Ensures a 4-digit random number
  return '$prefix-$timestamp-$randomSuffix';
}

class TotalPriceSection extends StatelessWidget {
  const TotalPriceSection({
    super.key,
    required this.itemsTotalPrice,
    required this.deliveryFee,
    required this.totalAmount,
    required this.totalPrice,
  });

  final double itemsTotalPrice;
  final double deliveryFee;
  final double totalAmount;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Item Total:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${itemsTotalPrice.toStringAsFixed(2)} birr',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delivery Fee:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${deliveryFee.toStringAsFixed(2)} birr',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${totalAmount.toStringAsFixed(2)} Birr',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            minimumSize: const Size.fromHeight(50), // Set the button height
          ),
          onPressed: () async {
            // Assuming totalPrice is calculated elsewhere in your code.
            final double totalAmount =
                totalPrice; // Use your totalPrice calculation logic here
            String txRef = generateTxRef(
                'gh'); // Implement your transaction reference generator

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
                Provider.of<CartProvider>(context, listen: false).clearCart();
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
    );
  }
}
