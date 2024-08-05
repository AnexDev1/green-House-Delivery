import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/cart_item.dart';
import 'package:greenhouse/src/services/firebase_database_service.dart';

import '../view/order/payment_success.dart';

class PaymentService {
  FirebaseDatabaseService _firebaseDatabaseService = FirebaseDatabaseService();

  Future<Map<String, dynamic>> verifyPayment(String txRef) async {
    try {
      return await Chapa.getInstance.verifyPayment(txRef: txRef);
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
      rethrow;
    }
  }

  Future<void> verifyPaymentAndAddOrder(BuildContext context, String txRef,
      List<CartItem> cartItems, String userEmail, String orderTime) async {
    try {
      Map<String, dynamic> verificationResult = await verifyPayment(txRef);

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
        await _firebaseDatabaseService.addOrderData(orderData);
      } else {
        print('Payment verification failed: ${verificationResult['message']}');
      }
    } catch (e) {
      print(
          'Error during payment verification and order addition: ${e.toString()}');
    }
  }

  Future<void> startPayment(
      BuildContext context,
      String txRef,
      String username,
      String phoneNumber,
      double totalAmount,
      List<CartItem> cartItems,
      String userEmail,
      String orderTime) async {
    await Chapa.getInstance.startPayment(
      firstName: username,
      phoneNumber: phoneNumber,
      context: context,
      amount: totalAmount.toString(),
      currency: 'ETB',
      txRef: txRef,
      onInAppPaymentSuccess: (successMsg) async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentSuccess(
              txRef: txRef,
            ),
          ),
        );
        print("Payment Success: $successMsg");

        await verifyPaymentAndAddOrder(
            context, txRef, cartItems, userEmail, orderTime);
      },
      onInAppPaymentError: (errorMsg) {
        print("Payment Error: $errorMsg");
      },
    );
  }
}
