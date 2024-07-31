import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/models/cart_item.dart';
import 'package:http/http.dart' as http;

import '../view/cart/view/total_price_section.dart';

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

      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
