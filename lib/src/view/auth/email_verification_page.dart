import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/main_screen.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Timer? _timer;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _startEmailVerificationCheck();
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _checkEmailVerified();
    });
  }

  Future<void> _checkEmailVerified() async {
    await _user?.reload();
    _user = _auth.currentUser;
    if (_user?.emailVerified ?? false) {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      setState(() {
        _isVerified = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/check_email.png'),
            SizedBox(height: 20),
            Text(
              'Please check your email to verify your account.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
