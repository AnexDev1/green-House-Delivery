import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/services/firebase_auth_service.dart';
import 'package:greenhouse/src/services/firebase_database_service.dart';

import '../view/auth/signup_page.dart';

class UpdateProfileController {
  FirebaseDatabaseService _authService = FirebaseDatabaseService();
  FirebaseAuthService _auth = FirebaseAuthService();
  Future<void> updateName(BuildContext context,
      TextEditingController nameController, Function setLoading) async {
    setLoading(true);
    await _authService.updateName(nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Name updated successfully')),
    );
    Navigator.pop(context, true);
    nameController.clear();
    setLoading(false);
  }

  Future<void> updatePassword(
      BuildContext context,
      TextEditingController oldPasswordController,
      TextEditingController newPasswordController,
      TextEditingController confirmNewPasswordController,
      Function setLoading) async {
    setLoading(true);
    if (newPasswordController.text == confirmNewPasswordController.text) {
      try {
        await _auth.updatePassword(
            oldPasswordController.text, newPasswordController.text);
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.pop(context, true);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New passwords do not match')),
      );
    }
    setLoading(false);
  }

  Future<void> deleteAccount(BuildContext context, String password) async {
    try {
      await _auth.deleteAccount(password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }
}