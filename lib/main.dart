import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/main_screen.dart';
import 'package:greenhouse/src/providers/cartProvider.dart';
import 'package:greenhouse/src/providers/productProvider.dart';
import 'package:greenhouse/src/view/auth/login_page.dart';
import 'package:greenhouse/src/view/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool seenOnboarding = await checkFirstTime();
  bool isDarkMode = await getDarkModePreference();
  Chapa.configure(privateKey: "CHASECK_TEST-o96iTnMmMniteVl7LrktzfT0h5tqUXhb");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: MyApp(
          seenOnboarding: seenOnboarding,
          isDarkMode: isDarkMode), // Your main app widget
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

Future<bool> getDarkModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode') ?? false;
}

class MyApp extends StatefulWidget {
  final bool seenOnboarding;
  final bool isDarkMode;
  const MyApp(
      {super.key, required this.seenOnboarding, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  _MyAppState() : _themeMode = ThemeMode.light;

  @override
  void initState() {
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    super.initState();
  }

  void setTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  ThemeMode get themeMode => _themeMode;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: widget.seenOnboarding
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
