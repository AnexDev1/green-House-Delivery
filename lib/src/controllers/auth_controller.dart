import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/src/main_screen.dart';
import 'package:greenhouse/src/services/firebase_auth_service.dart';
import 'package:greenhouse/src/view/auth/email_verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupLogic {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> handleSignup(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController phoneNumberController,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      Function setLoading,
      Function setUsernameError,
      Function setPhoneNumberError,
      Function setEmailError,
      Function setPasswordError,
      Function setConfirmPasswordError) async {
    setLoading(true);
    setUsernameError(null);
    setPhoneNumberError(null);
    setEmailError(null);
    setPasswordError(null);
    setConfirmPasswordError(null);

    try {
      // Validate input fields
      if (usernameController.text.isEmpty) {
        setUsernameError("Username cannot be empty");
        throw Exception("Validation failed");
      }
      if (phoneNumberController.text.isEmpty) {
        setPhoneNumberError("Phone number cannot be empty");
        throw Exception("Validation failed");
      }
      if (emailController.text.isEmpty) {
        setEmailError("Email cannot be empty");
        throw Exception("Validation failed");
      }
      if (!emailController.text.contains('@')) {
        setEmailError("Invalid email address");
        throw Exception("Validation failed");
      }
      if (passwordController.text.isEmpty) {
        setPasswordError("Password cannot be empty");
        throw Exception("Validation failed");
      }
      if (confirmPasswordController.text != passwordController.text) {
        setConfirmPasswordError("Passwords do not match");
        throw Exception("Validation failed");
      }

      // Perform signup operation
      User? user = await _authService.signUpWithEmailPassword(
          emailController.text, passwordController.text);
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', usernameController.text);
        await prefs.setString('phoneNum', phoneNumberController.text);

        // Send OTP to email
        await user.sendEmailVerification();
        // Navigate to OTP verification page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationPage(),
          ),
        );
      } else {
        throw Exception("Registration failed");
      }
    } catch (e) {
      setEmailError("An error occurred. Please try again.");
    } finally {
      setLoading(false);
    }
  }
}

class LoginLogic {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> handleLogin(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      Function setLoading,
      Function setEmailError,
      Function setPasswordError) async {
    setLoading(true);
    setEmailError(null);
    setPasswordError(null);

    try {
      // Validate input fields
      if (emailController.text.isEmpty) {
        setEmailError("Email cannot be empty");
        throw Exception("Validation failed");
      }
      if (!emailController.text.contains('@')) {
        setEmailError("Invalid email address");
        throw Exception("Validation failed");
      }
      if (passwordController.text.isEmpty) {
        setPasswordError("Password cannot be empty");
        throw Exception("Validation failed");
      }

      // Perform login operation
      User? user = await _authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
      if (user != null) {
        // Navigate to home page or dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      } else {
        throw Exception("Login failed");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setEmailError("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        setPasswordError("Wrong password provided.");
      } else {
        setEmailError("An error occurred. Please try again.");
      }
    } catch (e) {
      setEmailError("An error occurred. Please try again.");
      return null;
    } finally {
      setLoading(false);
    }
  }
}
