import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryService {
  Future<List<Map<String, dynamic>>> fetchOrderHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ordersRef = FirebaseDatabase.instance.ref('payments');
      DataSnapshot snapshot = await ordersRef.get();
      List<Map<String, dynamic>> orders = [];
      for (var child in snapshot.children) {
        var order = Map<String, dynamic>.from(child.value as Map);
        if (order['userEmail'] == user.email) {
          orders.add(order);
        }
      }
      return orders;
    }
    return [];
  }
}

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    OrderHistoryService orderHistoryService = OrderHistoryService();
    List<Map<String, dynamic>> fetchedOrders =
        await orderHistoryService.fetchOrderHistory();
    setState(() {
      orders = fetchedOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final DateTime orderDate = DateTime.parse(order['orderTime']);
                final String formattedDate =
                    DateFormat('dd MMM yyyy').format(orderDate);

                return Card(
                  color: Color(0xff3fb31e),
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
                          'TxRef: ${order['paymentData']['reference']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Amount: ${order['paymentData']['amount']} birr',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to order details page if needed
                    },
                  ),
                );
              },
            ),
    );
  }
}
