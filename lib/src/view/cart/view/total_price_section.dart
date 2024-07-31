import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/controllers/auth_controller.dart';
import 'package:greenhouse/src/models/cart_item.dart';
import 'package:greenhouse/src/services/payment_service.dart';
import 'package:intl/intl.dart';

import '../../../utils/payment_utls.dart';
import '../../order/payment_success.dart';

String username = '';
String phoneNumber = '';
String? userEmail = '';
String orderTime = '';

class TotalPriceSection extends StatefulWidget {
  const TotalPriceSection(
      {super.key,
      required this.itemsTotalPrice,
      required this.deliveryFee,
      required this.totalAmount,
      required this.totalPrice,
      required this.cartItems});

  final double itemsTotalPrice;
  final double deliveryFee;
  final double totalAmount;
  final double totalPrice;
  final List<CartItem> cartItems;

  @override
  State<TotalPriceSection> createState() => _TotalPriceSectionState();
}

class _TotalPriceSectionState extends State<TotalPriceSection> {
  @override
  void initState() {
    loadUsername().then((loadedUsername) {
      setState(() {
        username = loadedUsername;
      });
      loadPhoneNumber().then((loadedPhoneNumber) {
        setState(() {
          phoneNumber = loadedPhoneNumber;
        });
      });

      userEmail = FirebaseAuth.instance.currentUser?.email;
      orderTime = DateFormat('yyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Item Total:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${widget.itemsTotalPrice.toStringAsFixed(2)} birr',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delivery Fee:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
                '${widget.cartItems.isEmpty ? '0.00' : widget.deliveryFee.toStringAsFixed(2)} birr',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
                '${widget.cartItems.isEmpty ? '0.00' : widget.totalAmount.toStringAsFixed(2)} Birr',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff3fb31e),
            minimumSize: const Size.fromHeight(50), // Set the button height
          ),
          onPressed: () async {
            final SignupLogic _authController = SignupLogic();
            bool isVerified = await _authController.isEmailVerified();
            final double totalAmount = widget.totalAmount;
            String txRef = generateTxRef('gh');
            isVerified
                ? await Chapa.getInstance.startPayment(
                    firstName: username,
                    phoneNumber: phoneNumber,
                    context: context,
                    amount: totalAmount.toString(),
                    currency: 'ETB',
                    txRef: txRef,
                    onInAppPaymentSuccess: (successMsg) async {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ThankYouPage(
                              txRef: txRef, amount: totalAmount.toString()),
                        ),
                      );
                      print("Payment Success: $successMsg");

                      PaymentService paymentService = PaymentService();
                      await paymentService.verifyPayment(
                          context, txRef, widget.cartItems);
                    },
                    onInAppPaymentError: (errorMsg) {
                      print("Payment Error: $errorMsg");
                    },
                  )
                : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please verify your email before proceeding'),
                  ));
          },
          child: const Text('Proceed to pay',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
}
