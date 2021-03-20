import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
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
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          basicScreenColor(),
          _buildUserInfo(user, firebaseAuth),
        ],
      ),
    );
  }

  Widget _buildUserInfo(User user, FirebaseAuth firebaseAuth) {
    return Column(
      children: [
        const SizedBox(height: 8),
        if (user.uid != null)
          Text(
            user.uid,
            style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
          ),
        const SizedBox(height: 8),
        logOutButton(firebaseAuth),
      ],
    );
  }

  Widget logOutButton(FirebaseAuth firebaseAuth) {
    return Container(
      width: 310,
      height: 40,
      child: FlatButton(
        onPressed: () => {_signOut(context, firebaseAuth)},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(GlobalValues.redTextbg),
        child: Text(
          "Sign out",
          style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
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
