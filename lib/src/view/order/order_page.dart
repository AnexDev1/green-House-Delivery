import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Order on ${order['orderTime']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: ${order['paymentData']['amount']} birr'),
                        const SizedBox(height: 8.0),
                        Text('Items:'),
                        ...order['cartItems'].map<Widget>((item) {
                          return Text(
                              '${item['name']} - ${item['quantity']} x ${item['price']} birr');
                        }).toList(),
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
