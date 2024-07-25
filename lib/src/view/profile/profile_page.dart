import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/auth/login_page.dart'; // Ensure you have the correct path for your LoginPage
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadUsername().then((loadedUsername) {
      setState(() {
        _username = loadedUsername;
      });
    });
  }

  Future<String> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ??
        'User'; // Default to 'User' if not found
  }

  // Future<String> _loadPhoneNumber() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('phoneNum') ??
  //       '09 ** ** ** **'; // Default to 'number' if not found
  // }

  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/men/33.jpg'),
            ),
            const SizedBox(height: 20),

// Replace the static text with a FutureBuilder to load the username
            Text(
              _username,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

// Method to load username from SharedPreference
            const SizedBox(height: 10),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            // Add more profile details here
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
