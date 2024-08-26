// lib/src/view/order/order_history_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_tracker/order_tracker.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  color: Colors.grey[500],
                  //     ? Colors.amber
                  //     : Color(0xff3fb31e),
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
                                color: Colors.black,
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
                        OrderTrackingWidget(
                          orderStatus: order['orderStatus'],
                          formattedDate: formattedDate,
                        ),
                      ],
                    ),
                    onTap: () {
                      final Uri _url = Uri.parse(
                          'https://checkout.chapa.co/checkout/test-payment-receipt/${order['paymentData']['reference']}');
                      Future<void> _launchUrl() async {
                        if (!await launchUrl(
                          _url,
                          mode: LaunchMode.inAppWebView,
                          browserConfiguration:
                              const BrowserConfiguration(showTitle: true),
                        )) {
                          throw Exception('Couldnt launch $_url');
                        }
                      }

                      _launchUrl();
                    },
                  ),
                );
              },
            ),
    );
  }
}

class OrderTrackingWidget extends StatelessWidget {
  final String orderStatus;
  final formattedDate;
  const OrderTrackingWidget(
      {required this.orderStatus, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    List<TextDto> orderList = [
      TextDto("Your order has been placed", "${formattedDate} - 10:47pm"),
      TextDto("Seller has processed your order", "Sun, 27th Mar '22 - 10:19am"),
      TextDto("Your item has been picked up by courier partner.",
          "Tue, 29th Mar '22 - 5:00pm"),
    ];

    List<TextDto> shippedList = [
      TextDto("Your order has been shipped", "Tue, 29th Mar '22 - 5:04pm"),
      TextDto("Your item has been received in the nearest hub to you.", null),
    ];

    List<TextDto> outOfDeliveryList = [
      TextDto("Your order is out for delivery", "Thu, 31th Mar '22 - 2:27pm"),
    ];

    List<TextDto> deliveredList = [
      TextDto("Your order has been delivered", "Thu, 31th Mar '22 - 3:58pm"),
    ];

    Status status;
    switch (orderStatus) {
      case 'pending':
        status = Status.order;
        break;
      case 'picked up':
        status = Status.shipped;
        break;
      case 'delivering':
        status = Status.outOfDelivery;
        break;
      case 'delivered':
        status = Status.delivered;
        break;
      default:
        status = Status.order;
    }

    return OrderTracker(
      status: status,
      activeColor: Colors.green,
      inActiveColor: Colors.grey[300],
      orderTitleAndDateList: orderList,
      shippedTitleAndDateList: shippedList,
      outOfDeliveryTitleAndDateList: outOfDeliveryList,
      deliveredTitleAndDateList: deliveredList,
    );
  }
}
