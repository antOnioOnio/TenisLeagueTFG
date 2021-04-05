import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelMessages.dart';
import 'package:tenisleague100/models/ModelPlace.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/FirestorePaths.dart';

import 'firestore_service.dart';

class Database {
  Database({@required this.uid});
  final String uid;
  ModelUserLeague _currentUser;
  final _service = FirestoreService.instance;

  Future<void> registerUser(ModelUserLeague userLeague) async {
    await _service.setData(path: FirestorePath.createUser(uid), data: userLeague.toMap());
  }

  Stream<List<ModelUserLeague>> userStream() => _service.collectionStream(
        path: FirestorePath.users,
        builder: (data, documentId) => ModelUserLeague.fromJson(data),
      );

  Future<ModelUserLeague> getCurrentUser() async {
    if (_currentUser == null) {
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.users);
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      for (var obj in allData) {
        ModelUserLeague user = new ModelUserLeague.fromJson(obj);
        if (user.id == this.uid) {
          _currentUser = user;
        }
      }
    }
    return _currentUser;
  }

  Future<List<ModelUserLeague>> getUserCollection() async {
    List<ModelUserLeague> usersToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.users);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      usersToReturn.add(new ModelUserLeague.fromJson(obj));
    }
    return usersToReturn;
  }

  Stream<List<ModelMessage>> messagesStream(String idUser) => _service.collectionStream(
        path: FirestorePath.chats(idUser),
        builder: (data, documentId) => ModelMessage.fromJson(data),
        sort: (msg1, msg2) => msg2.createdAt.compareTo(msg1.createdAt),
      );

  Future sendMessage(String idUser, String message) async {
    ModelUserLeague currentUser = await getCurrentUser();
    final newMessage = new ModelMessage(
      idUser: currentUser.id,
      idUserSendTo: idUser,
      image: currentUser.image,
      userName: currentUser.fullName,
      message: message,
      createdAt: DateTime.now(),
    );
    await _service.addData(path: FirestorePath.chats(idUser), data: newMessage.toMap());
    await _service.addData(path: FirestorePath.chats(currentUser.id), data: newMessage.toMap());
  }

  Future<void> sendPost(ModelPost post) async {
    await _service.setData(
      path: FirestorePath.posts(post.id),
      data: post.toMap(),
    );
  }

  Stream<List<ModelPost>> postStream() => _service.collectionStream(
        path: FirestorePath.postsCollection(),
        builder: (data, documentId) => ModelPost.fromJson(data),
        sort: (msg1, msg2) => msg2.createdAt.compareTo(msg1.createdAt),
      );

  Future<void> deletePost(String id) async {
    await _service.deleteData(
      path: FirestorePath.posts(id),
    );
  }

  Stream<List<ModelComment>> commentStream(String idPost) => _service.collectionStream(
        path: FirestorePath.commentCollection(idPost),
        builder: (data, documentId) => ModelComment.fromJson(data),
        sort: (msg1, msg2) => msg2.createdAt.compareTo(msg1.createdAt),
      );

  Future<void> sendComment(ModelComment comment, String postId) async {
    await _service.setData(
      path: FirestorePath.commentDoc(postId, comment.id),
      data: comment.toJson(),
    );
  }

  Future<void> deleteComment(String idPost, String commentId) async {
    await _service.deleteData(path: FirestorePath.commentDoc(idPost, commentId));
  }

  Future<void> sendPlace(ModelPlace modelPlace) async {
    await _service.setData(
      path: FirestorePath.places(modelPlace.id),
      data: modelPlace.toMap(),
    );
  }

  Future<List<ModelPlace>> getPlacesCollection() async {
    List<ModelPlace> placesToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.placesCollection());
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      placesToReturn.add(new ModelPlace.fromJson(obj));
    }
    return placesToReturn;
  }
}
