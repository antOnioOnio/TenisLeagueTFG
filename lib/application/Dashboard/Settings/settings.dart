import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import '../../top_providers.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("something"),
        actions: <Widget>[
          FlatButton(
            key: const Key("Log out"),
            child: const Text(
              "Strings.logout",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _signOut(context, firebaseAuth),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }


  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        const SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      showAlertDialog(
        context: context,
        title: 'Error',
        content: "Error signing out",
        defaultActionText: 'OK',
        requiredCallback: false,
      );
    }
  }
}
