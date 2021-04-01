import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/database.dart';

class ForumViewModel with ChangeNotifier {
  final Database database;
  ModelUserLeague _currentUser;
  Uint8List _bytesImage;
  bool isLoading = true;
  ForumViewModel({@required this.database});

  initUser() async {
    print("initUser VM called");
    _currentUser = await database.getCurrentUser();
    _bytesImage = base64Decode(_currentUser.image);
    isLoading = false;
    notifyListeners();
  }

  void callMethod() {
    database.method();
  }

  bool get loading => isLoading;
  ModelUserLeague get user => _currentUser;
  Uint8List get imageUser => _bytesImage;
}
