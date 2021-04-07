import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelPlace.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
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

  Future<void> addMatch(String contentToPost) async{
    ModelPost modelPost = new ModelPost(
        id: generateUuid(),
        idUser: _currentUser.id,
        nameOfUser: _currentUser.fullName,
        content: contentToPost,
        imageUser: _currentUser.image,
        postType: ModelPost.typeProPMatch,
        createdAt: DateTime.now());

    await sendPost(modelPost);
  }

  Future<void> addPicture(String contentToPost, String image64)async{
    ModelPost modelPost = new ModelPost(
      id: generateUuid(),
      idUser: _currentUser.id,
      nameOfUser: _currentUser.fullName,
      content: contentToPost,
      imageUser: _currentUser.image,
      image: image64,
      postType: ModelPost.typePicture,
      createdAt: DateTime.now(),
    );
    await sendPost(modelPost);
  }
  Future<void> addEvent(String contentToPost) async{
    ModelPost modelPost = new ModelPost(
        id: generateUuid(),
        idUser: _currentUser.id,
        nameOfUser: _currentUser.fullName,
        content: contentToPost,
        imageUser: _currentUser.image,
        postType: ModelPost.typeEvent,
        createdAt: DateTime.now());

    await sendPost(modelPost);
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
  Future<void> deleteComment(String idPost, String commentId) async => await database.deleteComment(idPost, commentId);
  Future<List<ModelPlace>> getPlacesCollection() async => await database.getPlacesCollection();
  Future<void> sendNewPlace(String nameOfPlace) async {
    ModelPlace place = new ModelPlace(id: generateUuid(), name: nameOfPlace);
    await database.sendPlace(place);
  }

  bool get loading => isLoading;
  ModelUserLeague get user => _currentUser;
  Uint8List get imageUser => _bytesImage;
}
