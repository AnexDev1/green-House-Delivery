import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenhouse/main.dart';
import 'package:greenhouse/src/models/cart_item.dart';
import 'package:greenhouse/src/services/firebase_database_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../view/order/payment_success.dart';

enum OrderStatus {
  pending,
  delivered,
}

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

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted
    } else if (status.isDenied) {
      // Permission denied
    } else if (status.isPermanentlyDenied) {
      // Open app settings
      openAppSettings();
    }
  }

  Future<void> checkLocationServices() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      // Location services are disabled
      await Geolocator.openLocationSettings();
    }
  }

  Future<Position> getCurrentLocation() async {
    await checkLocationServices();
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> verifyPaymentAndAddOrder(
      BuildContext context,
      String txRef,
      List<CartItem> cartItems,
      String userEmail,
      String orderTime,
      Position currentPosition) async {
    try {
      Map<String, dynamic> verificationResult = await verifyPayment(txRef);

      if (verificationResult['status'] == 'success') {
        var paymentData = verificationResult['data'];
        var orderData = {
          'location': {
            'latitude': currentPosition.latitude,
            'longitude': currentPosition.longitude,
          },
          'paymentData': paymentData,
          'orderStatus': OrderStatus.pending.toString().split('.').last,
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
        print('Order Data : $orderData');
        await _firebaseDatabaseService.addOrderData(orderData);
      } else {
        print('Payment verification failed: ${verificationResult['message']}');
      }
    } catch (e) {
      print(
          'Error during payment verification and order addition: ${e.toString()}');
    }
  }

  Future<void> startPaymentInit(
      BuildContext context,
      String txRef,
      double totalAmount,
      List<CartItem> cartItems,
      String userEmail,
      String orderTime,
      Position currentPosition) async {
    String? username = await fetchUsername();
    String? phoneNumber = await fetchPhoneNumber();
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
              themeMode: MyApp.of(context).themeMode,
            ),
          ),
        );
        print("Payment Success: $successMsg");

        await verifyPaymentAndAddOrder(
            context, txRef, cartItems, userEmail, orderTime, currentPosition);
      },
      onInAppPaymentError: (errorMsg) {
        print("Payment Error: $errorMsg");
      },
    );
  }

  Future<String?> fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users');
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> users = snapshot.value as Map<dynamic, dynamic>;
        for (var key in users.keys) {
          if (users[key]['email'] == user.email) {
            return users[key]['username'];
          }
        }
      }
    }
    return null;
  }

  Future<String?> fetchPhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users');
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> users = snapshot.value as Map<dynamic, dynamic>;
        for (var key in users.keys) {
          if (users[key]['email'] == user.email) {
            return users[key]['phone'];
          }
        }
      }
    }
    return null;
  }
}
