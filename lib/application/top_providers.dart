
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tenisleague100/services/Database/Database.dart';

import 'Forum/ForumViewModel.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User>(
        (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final databaseProvider = Provider<Database>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.data?.value?.uid != null) {
    return Database(uid: auth.data.value.uid);
  }
  throw UnimplementedError();
});

final forumModelProvider = ChangeNotifierProvider<ForumViewModel>((ref) {
  final database = ref.watch(databaseProvider);
  return ForumViewModel(database: database);
});



final loggerProvider = Provider<Logger>((ref) => Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    printEmojis: false,
  ),
));
