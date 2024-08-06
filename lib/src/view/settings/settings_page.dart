import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = value;
      prefs.setBool('isDarkMode', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (bool value) {
              _toggleDarkMode(value);
              // Apply the theme change immediately
              if (value) {
                MyApp.of(context).setTheme(ThemeMode.dark);
              } else {
                MyApp.of(context).setTheme(ThemeMode.light);
              }
            },
          ),
        ],
      ),
    );
  }
}
