import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelPost.dart';
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

  Future<void> sendPost(ModelPost post) async {
    await database.sendPost(post);
  }

  Future<void> sendComment(ModelComment comment, String postId) async {
    await database.sendComment(comment, postId);
  }

  Future<void> deletePost(String postId) async {
    await database.deletePost(postId);
  }

  Stream<List<ModelPost>> postStream() => database.postStream();
  Stream<List<ModelComment>> commentStream(String idPost) => database.commentStream(idPost);
  Future<void> deleteComment(String idPost, String commentId) => database.deleteComment(idPost, commentId);
  bool get loading => isLoading;
  ModelUserLeague get user => _currentUser;
  Uint8List get imageUser => _bytesImage;
}
