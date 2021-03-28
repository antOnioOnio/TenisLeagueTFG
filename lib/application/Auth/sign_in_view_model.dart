import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tenisleague100/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({@required this.auth});
  final FirebaseAuth auth;
  bool isLoading = false;
  String error;
  String currentId;

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      error = null;
      final sp = context.read<SharedPreferencesService>(sharedPreferencesServiceProvider);
      sp.setCurrentUserId(auth.currentUser.uid);
    } on FirebaseAuthException catch (e) {
      print("e.code ==> " + e.code);
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        error = 'The email address is badly formatted.';
      } else {
        error = "Unknown error";
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> register(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      final sp = context.read<SharedPreferencesService>(sharedPreferencesServiceProvider);
      sp.setCurrentUserId(auth.currentUser.uid);
      currentId = auth.currentUser.uid;
      error = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      } else {
        error = "Unknown error";
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
