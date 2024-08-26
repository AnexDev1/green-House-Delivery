import 'package:flutter/material.dart';
import 'package:order_tracker/order_tracker.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrackingPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderTrackingPage({required this.order});

  @override
  Widget build(BuildContext context) {
    List<TextDto> orderList = [
      TextDto("Your order has been placed", "Fri, 25th Mar '22 - 10:47pm"),
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
    switch (order['orderStatus']) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            OrderTracker(
              status: status,
              activeColor: Colors.green,
              inActiveColor: Colors.grey[300],
              orderTitleAndDateList: orderList,
              shippedTitleAndDateList: shippedList,
              outOfDeliveryTitleAndDateList: outOfDeliveryList,
              deliveredTitleAndDateList: deliveredList,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final Uri _url = Uri.parse(
                    'https://checkout.chapa.co/checkout/test-payment-receipt/${order['paymentData']['reference']}');
                if (!await launchUrl(
                  _url,
                  mode: LaunchMode.inAppWebView,
                  browserConfiguration:
                      const BrowserConfiguration(showTitle: true),
                )) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: const Text('Show Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
