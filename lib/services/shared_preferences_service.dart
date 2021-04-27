import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const CURRENT_USER = 'currentUser';

  Future<void> setCurrentUserId(String userId)async{
    await sharedPreferences.setString(CURRENT_USER, userId);
  }

  Future<String> getCurrentUSerId()async =>
      await sharedPreferences.getString(CURRENT_USER) ?? "";
}
