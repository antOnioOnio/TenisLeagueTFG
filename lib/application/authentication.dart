import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/emptyContent.dart';

class AuthWidget extends ConsumerWidget {
  final Widget nonSignedInBuilder;
  final Widget signedInBuilder;

  AuthWidget({@required this.nonSignedInBuilder, @required this.signedInBuilder, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) => _data(context, user),
      loading: () => const Scaffold(
        body: CircularProgressIndicator(),
      ),
      error: (_, __) => const Scaffold(
        body: EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t load data right now.',
        ),
      ),
    );
  }

  Widget _data(BuildContext context, User user) {
    if (user != null) {
      return signedInBuilder;
    }
    return nonSignedInBuilder;
  }
}
