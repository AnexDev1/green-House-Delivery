import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/auth/login_page.dart';
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
          children: <Widget>[
            _profileRow(username: _username, userEmail: userEmail),
            const Divider(),
            _buildListTile(
              title: 'Language',
              icon: Icons.language,
              onTap: () {
                // Handle language change
              },
            ),
            _buildListTile(
              title: 'Preferences',
              icon: Icons.settings,
              onTap: () {
                // Handle preferences
              },
            ),
            _buildListTile(
              title: 'Get Help',
              icon: Icons.help,
              onTap: () {
                // Handle get help
              },
            ),
            _buildListTile(
              title: 'FAQ',
              icon: Icons.question_answer,
              onTap: () {
                // Handle FAQ
              },
            ),
            _buildListTile(
              title: 'Logout',
              icon: Icons.logout,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Navigate to login page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}

Widget _profileRow({required String username, required String userEmail}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const CircleAvatar(
        radius: 30,
        backgroundImage:
            NetworkImage('https://randomuser.me/api/portraits/men/33.jpg'),
      ),
      Column(
        children: [
          Text(
            username,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.keyboard_arrow_right,
        ),
      ),
    ],
  );
}
