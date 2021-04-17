import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelMessages.dart';
import 'package:tenisleague100/models/ModelPlace.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/FirestorePaths.dart';

import 'firestore_service.dart';

class Database {
  Database({@required this.uid});
  final String uid;
  ModelUserLeague _currentUser;
  List<ModelUserLeague> _everyUser = [];
  final _service = FirestoreService.instance;

  //-------------------------------------------------------------
  //                  Users
  //-------------------------------------------------------------
  Future<void> setUser(ModelUserLeague userLeague) async {
    print("STEP 3 update it in backend==> " + userLeague.currentScore.toString());
    await _service.setData(path: FirestorePath.userPath(uid), data: userLeague.toMap());
/*    Future.delayed(const Duration(seconds: 3), () async {
      await getUserCollection(true);
    });*/
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

/*  Future<List<ModelUserLeague>> getUserCollection(bool update) async {

      print("STEP 4: update users...as they have fucking changed");
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.users);
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      for (var obj in allData) {
        ModelUserLeague user = new ModelUserLeague.fromJson(obj);
        if(!_everyUser.contains(user)){
          _everyUser.add(user);
        }

      }
      print("STEP 5 now i should get it with increased score ==>" + _everyUser[0].currentScore.toString());
      return _everyUser;
    }
  }*/
/*

  Future<ModelUserLeague> getUserById(String userId) async {
    if(_everyUser.isEmpty) await getUserCollection(true);

    for (var user in _everyUser) {
      print("user id==> " + user.id);
      if (user.id == userId) {
        return user;
      }
    }
  }
*/

  //-------------------------------------------------------------
  //                    Messages
  //-------------------------------------------------------------
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

  //-------------------------------------------------------------
  //                  Posts
  //-------------------------------------------------------------
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

  //-------------------------------------------------------------
  //                        Commets
  //-------------------------------------------------------------
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

  //-------------------------------------------------------------
  //                  Places
  //-------------------------------------------------------------
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

  //-------------------------------------------------------------
  //                  League and matches
  //-------------------------------------------------------------
  Future<void> sendLeague(ModelLeague league) async {
    await _service.setData(
      path: FirestorePath.leagues(league.id),
      data: league.toMap(),
    );
  }

  Future<void> sendMatch(ModelMatch match) async {
    await _service.setData(
      path: FirestorePath.matches(match.idLeague, match.id),
      data: match.toJson(),
    );
  }

  Future<List<ModelLeague>> getLeaguesCollection() async {
    List<ModelLeague> leaguesToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.leaguesCollection);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      leaguesToReturn.add(new ModelLeague.fromJson(obj));
    }
    return leaguesToReturn;
  }

  Future<List<ModelMatch>> getMatchesCollection(String idLeague) async {
    List<ModelMatch> matchesToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.matchesCollection(idLeague));
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      matchesToReturn.add(new ModelMatch.fromJson(obj));
    }
    return matchesToReturn;
  }
}
