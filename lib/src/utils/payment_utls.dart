import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:shared_preferences/shared_preferences.dart';

String generateTxRef(String? prefix) {
  // Generate a random transaction reference with a custom prefix
  return TxRefRandomGenerator.generate(prefix: prefix);
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
