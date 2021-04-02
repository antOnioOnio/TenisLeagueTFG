import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenisleague100/application/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenisleague100/services/shared_preferences_service.dart';

import 'application/Auth/signIn.dart';
import 'application/Dashboard.dart';
//flutter packages pub run build_runner build --delete-conflicting-outputs

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(sharedPreferences),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final firebaseAuth = context.read(firebaseAuthProvider);
    return MaterialApp(
      title: 'Tennis League 100',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        nonSignedInBuilder: SignIn(),
        signedInBuilder: Dashboard(),
      ),
    );
  }
}
