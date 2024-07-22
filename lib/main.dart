import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/main_screen.dart';
import 'package:greenhouse/src/providers/cartProvider.dart';
import 'package:provider/provider.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'green house',
      theme: ThemeData(),
      home: const MainScreen(),
    );
  }
}
