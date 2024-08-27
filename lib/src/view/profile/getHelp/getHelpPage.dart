import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/controllers/auth_controller.dart';

class GetHelpPage extends StatefulWidget {
  const GetHelpPage({Key? key}) : super(key: key);

  @override
  _GetHelpPageState createState() => _GetHelpPageState();
}

class _GetHelpPageState extends State<GetHelpPage> {
  late Stream<User?> _userChanges;

  @override
  void initState() {
    super.initState();
    _userChanges = SignupLogic().userChanges;
  }

  void _sendVerificationEmail(BuildContext context) async {
    try {
      await SignupLogic().sendVerificationEmail();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Help'),
      ),
      body: StreamBuilder<User?>(
        stream: _userChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user != null && user.emailVerified) {
              return Center(child: Text('Your email is verified.'));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Need help?'),
                    ElevatedButton(
                      onPressed: () => _sendVerificationEmail(context),
                      child: Text('Verify Now'),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
