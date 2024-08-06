import 'package:flutter/material.dart';
import 'package:greenhouse/src/main_screen.dart';
import 'package:greenhouse/src/providers/cartProvider.dart';
import 'package:provider/provider.dart';

import 'home_button.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({Key? key, required this.txRef, required this.themeMode})
      : super(key: key);

  final String txRef;
  final ThemeMode themeMode;

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

Color themeColor = const Color(0xff267310);

class _PaymentSuccessState extends State<PaymentSuccess> {
  double screenWidth = 600;
  double screenHeight = 400;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    bool isDarkMode = widget.themeMode == ThemeMode.dark;
    Color textColor = isDarkMode ? Colors.white : const Color(0xFF32567A);
    Color subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/card.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Text(
              "Thank You!",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              " Payment done Successfully",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              "You will be redirected to the home page shortly\nor click here to return to home page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child: HomeButton(
                title: 'home',
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                  Provider.of<CartProvider>(context, listen: false).clearCart();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
