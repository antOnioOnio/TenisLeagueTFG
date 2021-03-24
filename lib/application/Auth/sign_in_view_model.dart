import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({@required this.auth});
  final FirebaseAuth auth;
  bool isLoading = false;
  String error;

  Future<void> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      error = null;
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

  Future<void> register(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.createUserWithEmailAndPassword(email: email, password: password);
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
