import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //check if email verified
  Future<bool> isEmailVerified(User user) async {
    await user.reload();
    return user.emailVerified;
  }

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    }
  }

  Future<void> deleteAccount(String password) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
    }
  }
}
