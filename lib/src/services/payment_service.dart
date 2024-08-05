import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/cart_item.dart';

class PaymentService {
  Future<void> verifyPayment(BuildContext context, String txRef,
      List<CartItem> cartItems, String userEmail, String orderTime) async {
    try {
      Map<String, dynamic> verificationResult =
          await Chapa.getInstance.verifyPayment(
        txRef: txRef,
      );

      if (verificationResult['status'] == 'success') {
        var paymentData = verificationResult['data'];
        var orderData = {
          'paymentData': paymentData,
          'orderStatus': 'pending',
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
      } else {
        print('Payment verification failed: ${verificationResult['message']}');
      }
    } on ChapaException catch (e) {
      if (e is AuthException) {
        print('Authentication error: ${e.toString()}');
      } else if (e is NetworkException) {
        print('Network error: ${e.toString()}');
      } else if (e is ServerException) {
        print('Server error: ${e.toString()}');
      } else if (e is VerificationException) {
        print('Verification error: ${e.toString()}');
      } else {
        print('Unknown error: ${e.toString()}');
      }
    }
  }
}
