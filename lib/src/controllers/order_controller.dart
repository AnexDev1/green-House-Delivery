// lib/src/services/order_history_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
