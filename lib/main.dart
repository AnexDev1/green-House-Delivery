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
    );
  }
}
