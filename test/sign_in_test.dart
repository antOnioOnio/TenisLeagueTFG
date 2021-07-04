import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tenisleague100/application/Auth/signIn.dart';
import 'package:tenisleague100/application/top_providers.dart';

import 'sign_in_test.mocks.dart';

@GenerateMocks([FirebaseAuth, NavigatorObserver])
void main() {
  group('sign-in page', () {
    MockFirebaseAuth mockFirebaseAuth;
    MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockNavigatorObserver = MockNavigatorObserver();
    });

    Future<void> pumpSignInPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            firebaseAuthProvider.overrideWithProvider(Provider((ref) => mockFirebaseAuth)),
          ],
          child: Consumer(builder: (context, watch, __) {
            final firebaseAuth = watch(firebaseAuthProvider);
            return MaterialApp(
              home: SignInPage(),
              navigatorObservers: [mockNavigatorObserver],
            );
          }),
        ),
      );
      verify(mockNavigatorObserver.didPush(any, any)).called(1);
    }
  });
}
