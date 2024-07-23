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
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(), // Your main app widget
    ),
  );
}

// Future<bool> checkFirstTime() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getBool('seenOnboarding') ?? false;
// }
//
// Future<void> setSeenOnboarding() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('seenOnboarding', true);
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _getStartupScreen(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Or some other loading widget
          }
          return snapshot.data ??
              const SizedBox(); // Fallback to an empty widget or loading screen
        },
      ),
    );
  }

  Future<Widget> _getStartupScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      return const OnboardingPage(); // Replace with your OnboardingPage widget
    } else if (FirebaseAuth.instance.currentUser == null) {
      return LoginPage(); // Replace with your LoginPage widget
    } else {
      return const MainScreen(); // Replace with your MainScreen widget
    }
  }
}
