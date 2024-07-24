import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/main_screen.dart';
import 'package:greenhouse/src/providers/cartProvider.dart';
import 'package:greenhouse/src/view/auth/login_page.dart';
import 'package:greenhouse/src/view/home/view/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool seenOnboarding = await checkFirstTime();
  Chapa.configure(privateKey: "CHASECK_TEST-o96iTnMmMniteVl7LrktzfT0h5tqUXhb");
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(seenOnboarding: seenOnboarding), // Your main app widget
    ),
  );
}

Future<bool> checkFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('seenOnboarding') ?? false;
}

Future<void> setSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('seenOnboarding', true);
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: seenOnboarding
          ? (FirebaseAuth.instance.currentUser == null
              ? LoginPage()
              : const MainScreen())
          : const OnboardingPage(),
      routes: {
        '/checkoutPage': (context) => const CheckoutPage(),
      },
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Text('Checkout Page Content Goes Here'),
      ),
    );
  }
}
