import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

String generateTxRef(String prefix) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomSuffix = Random()
      .nextInt(9999)
      .toString()
      .padLeft(4, '0'); // Ensures a 4-digit random number
  return '$prefix-$timestamp-$randomSuffix';
}

Future<String> loadUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ??
      'User'; // Default to 'User' if not found
}

Future<String> loadPhoneNumber() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('phoneNum') ??
      '09 ** ** ** **'; // Default to 'number' if not found
}
