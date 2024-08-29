import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

String generateTxRef(String? prefix) {
  // Generate a random transaction reference with a custom prefix
  return TxRefRandomGenerator.generate(prefix: prefix);
}

Stream<String> loadUsername() {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return _dbRef
        .child('users')
        .child(user.uid)
        .child('username')
        .onValue
        .map((event) {
      return event.snapshot.value as String? ?? 'User';
    });
  } else {
    return Stream.value('User');
  }
}

Future<String> loadPhoneNumber() async {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DataSnapshot snapshot =
        await _dbRef.child('users').child(user.uid).child('phoneNumber').get();
    if (snapshot.exists) {
      return snapshot.value as String;
    }
  }
  return '09 ** ** ** **'; // Default to 'number' if not found
}
