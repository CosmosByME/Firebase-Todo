import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/shared_preference/prefs.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signInUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = _auth.currentUser;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Successfully Signed In")));
      return user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<User?> signUpUser(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Successfully Signed Up")));
      return user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static void signOutUser(BuildContext context) async {
    await _auth.signOut();
    Prefs.deleteUserId().then((value) {
      //Navigation
    });
  }
}
