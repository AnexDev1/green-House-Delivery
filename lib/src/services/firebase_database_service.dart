import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/product.dart';

class FirebaseDatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateName(String name) async {
    User? user = _auth.currentUser;
    if (user != null && name.isNotEmpty) {
      await _dbRef.child('users').child(user.uid).update({
        'username': name,
      });
    }
  }

  Future<List<Product>> fetchProducts() async {
    DataSnapshot snapshot = await _dbRef.child('products').get();
    if (snapshot.exists) {
      List<Product> products = [];
      final Map<dynamic, dynamic> productsMap =
          snapshot.value as Map<dynamic, dynamic>;
      productsMap.forEach((key, value) {
        final product = Product.fromMap(value as Map<dynamic, dynamic>);
        products.add(product);
      });
      return products;
    } else {
      return [];
    }
  }

  Future<void> addOrderData(Map<String, dynamic> orderData) async {
    await _dbRef.child('payments').push().set(orderData).then((_) {
      print('Document added');
    }).catchError((error) {
      print('Error adding document: $error');
    });
  }
}
