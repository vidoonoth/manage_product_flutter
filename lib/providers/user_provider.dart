import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  UserModel? _user;
  UserModel? get user => _user;

  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      _user = UserModel.fromFirebase(userCredential.user);

      final prefs = await SharedPreferences.getInstance();
      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await prefs.setString('auth_token', token);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Login Error: $e');
      rethrow;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _user = null;
    notifyListeners();
  }
}
