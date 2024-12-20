import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/utils/payment_utls.dart';
import 'package:greenhouse/src/view/auth/login_page.dart';
import 'package:greenhouse/src/view/profile/getHelp/getHelpPage.dart';
import 'package:greenhouse/src/view/profile/settings/settings_page.dart';
import 'package:greenhouse/src/view/profile/updateProfile/updateProfilePage.dart';
import 'package:provider/provider.dart';

import '../../providers/cartProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Loading...';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfilePage()),
                  );
                  if (result == true) {
                    setState(
                        () {}); // Reload username after returning from update page
                  }
                },
                child: StreamBuilder<String>(
                  stream: loadUsername(),
                  builder: (context, snapshot) {
                    String username = snapshot.data ?? 'Loading...';
                    return _profileRow(
                        context: context,
                        username: username,
                        userEmail: userEmail);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                'Account',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            Column(
              children: [
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                    // Handle preferences
                  },
                ),
                _buildListTile(
                  title: 'Get Help',
                  icon: Icons.help,
                  onTap: () {
                    // Handle get help
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GetHelpPage(),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  title: 'FAQ',
                  icon: Icons.question_answer,
                  onTap: () {
                    // Handle FAQ
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Color(0xffd90b34),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Color(0xffd90b34)),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Provider.of<CartProvider>(context, listen: false)
                        .clearCart();

                    // Navigate to login page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ],
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
      leading: Icon(
        icon,
        color: Color(0xff3fb31e),
      ),
      title: Text(title),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}

Widget _profileRow(
    {required BuildContext context,
    required String username,
    required String userEmail}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const CircleAvatar(
        radius: 30,
        backgroundImage:
            NetworkImage('https://randomuser.me/api/portraits/lego/4.jpg'),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UpdateProfilePage()),
              ),
          icon: Icon(Icons.keyboard_arrow_right))
    ],
  );
}
