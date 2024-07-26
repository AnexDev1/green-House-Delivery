import 'dart:convert';
import 'dart:math';

import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../order/payment_success.dart';

String username = '';
String phoneNumber = '';
String? userEmail = '';
String orderTime = '';

class PaymentService {
  Future<void> verifyPayment(BuildContext context, String transactionId,
      List<CartItem> cartItems) async {
    var headers = {
      'Authorization': 'Bearer CHASECK_TEST-o96iTnMmMniteVl7LrktzfT0h5tqUXhb'
    };
    var request = http.Request('GET',
        Uri.parse('https://api.chapa.co/v1/transaction/verify/$transactionId'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      var parsedResponse = json.decode(jsonResponse);
      var paymentData = parsedResponse['data'];
      print(cartItems);
      var orderData = {
        'paymentData': paymentData,
        'cartItems': cartItems
            .map((item) => {
                  'name': item.name,
                  'price': item.price,
                  'quantity': item.quantity,
                })
            .toList(),
        'userEmail': userEmail,
        'orderTime': orderTime,
      };
      DatabaseReference ref = FirebaseDatabase.instance.ref('payments');
      await ref.push().set(orderData).then((_) {
        print('Document added');
      }).catchError((error) {
        print('Error adding document: $error');
      });

      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}

String generateTxRef(String prefix) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomSuffix = Random()
      .nextInt(9999)
      .toString()
      .padLeft(4, '0'); // Ensures a 4-digit random number
  return '$prefix-$timestamp-$randomSuffix';
}

Future<String> _loadUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ??
      'User'; // Default to 'User' if not found
}

Future<String> _loadPhoneNumber() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('phoneNum') ??
      '09 ** ** ** **'; // Default to 'number' if not found
}

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
    _loadUsername().then((loadedUsername) {
      setState(() {
        username = loadedUsername;
      });
      _loadPhoneNumber().then((loadedPhoneNumber) {
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
            Text('${widget.deliveryFee.toStringAsFixed(2)} birr',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${widget.totalAmount.toStringAsFixed(2)} Birr',
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
                widget.totalPrice; // Use your totalPrice calculation logic here
            String txRef = generateTxRef(
                'gh'); // Implement your transaction reference generator

            await Chapa.getInstance.startPayment(
              firstName: username,
              // lastName: userLastName,
              phoneNumber: phoneNumber,
              context: context,
              amount: totalAmount.toString(),
              currency: 'ETB',
              txRef: txRef,
              onInAppPaymentSuccess: (successMsg) async {
                // Handle successful payment here
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ThankYouPage(
                        txRef: txRef, amount: totalAmount.toString()),
                  ),
                );
                print("Payment Success: $successMsg");

                // Verify payment
                PaymentService paymentService = PaymentService();
                await paymentService.verifyPayment(
                    context, txRef, widget.cartItems);
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
