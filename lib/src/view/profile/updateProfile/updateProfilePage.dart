import 'package:flutter/material.dart';
import 'package:greenhouse/src/view/auth/signup_page.dart';

import '../../../controllers/profile_controller.dart';
import 'custom_fields.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final UpdateProfileController _controller = UpdateProfileController();
  bool _isNameLoading = false;
  bool _isPasswordLoading = false;

  void _setNameLoading(bool isLoading) {
    setState(() {
      _isNameLoading = isLoading;
    });
  }

  void _setPasswordLoading(bool isLoading) {
    setState(() {
      _isPasswordLoading = isLoading;
    });
  }

  void _showDeleteConfirmationDialog() {
    TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete your account?'),
              SizedBox(height: 10),
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.deleteAccount(context, passwordController.text);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _nameController,
                          labelText: 'Name',
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _isNameLoading
                              ? null
                              : () => _controller.updateName(
                                  context, _nameController, _setNameLoading),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle:
                                TextStyle(fontSize: 16, color: textColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isNameLoading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(textColor),
                                )
                              : Text('Update Name',
                                  style: TextStyle(color: textColor)),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _oldPasswordController,
                          labelText: 'Old Password',
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _newPasswordController,
                          labelText: 'New Password',
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _confirmNewPasswordController,
                          labelText: 'Confirm New Password',
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _isPasswordLoading
                              ? null
                              : () => _controller.updatePassword(
                                  context,
                                  _oldPasswordController,
                                  _newPasswordController,
                                  _confirmNewPasswordController,
                                  _setPasswordLoading),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle:
                                TextStyle(fontSize: 16, color: textColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isPasswordLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                )
                              : Text('Update Password',
                                  style: TextStyle(color: textColor)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _showDeleteConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle:
                                TextStyle(fontSize: 16, color: textColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Delete Account',
                              style: TextStyle(color: textColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
