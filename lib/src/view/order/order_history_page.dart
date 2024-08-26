// lib/src/view/order/order_history_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'order_tracking_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> orders = [];
  late DatabaseReference ordersRef;
  late String currentUserEmail;

  @override
  void initState() {
    super.initState();
    ordersRef = FirebaseDatabase.instance.ref().child('payments');
    currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    listenToOrderChanges();
  }

  void listenToOrderChanges() {
    ordersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> fetchedOrders = [];
      data.forEach((key, value) {
        final order = Map<String, dynamic>.from(value);
        if (order['userEmail'] == currentUserEmail) {
          fetchedOrders.add(order);
        }
      });
      setState(() {
        orders = fetchedOrders;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Center(
              child: Text('No Orders Found'),
            ))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                final DateTime orderDate = DateTime.parse(order['orderTime']);
                final String formattedDate =
                    DateFormat('dd MMM yyyy').format(orderDate);

                return Card(
                  color: order['orderStatus'] == 'pending'
                      ? Colors.amber
                      : Color(0xff3fb31e),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Name: ${order['paymentData']['first_name']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Amount: ${order['paymentData']['amount']} birr',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Status: ${order['orderStatus']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingPage(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
