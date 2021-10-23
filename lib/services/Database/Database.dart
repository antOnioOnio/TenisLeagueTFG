import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelMessages.dart';
import 'package:tenisleague100/models/ModelNotification.dart';
import 'package:tenisleague100/models/ModelPlace.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/FirestorePaths.dart';
import 'package:tenisleague100/services/Notifications/FirebaseNotifications.dart';

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
    await _service.setData(path: FirestorePath.userPath(userLeague.id), data: userLeague.toMap());
  }

  Stream<List<ModelUserLeague>> usersStream() => _service.collectionStream(
        path: FirestorePath.users,
        builder: (data, documentId) => ModelUserLeague.fromJson(data),
        sort: (user1, user2) => user2.currentScore.compareTo(user1.currentScore),
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
    if (_everyUser.isEmpty) {
      List<ModelUserLeague> usersToReturn = [];
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.users);
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      for (var obj in allData) {
        _everyUser.add(new ModelUserLeague.fromJson(obj));
      }
    }

    return _everyUser;
  }

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
    //sendCustomNotification("Has recibido un mensaje nuevo", "Tenis 100 mensaje", idUser);
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

  Stream<List<ModelLeague>> leagueStream() => _service.collectionStream(
        path: FirestorePath.leaguesStream,
        builder: (data, documentId) => ModelLeague.fromJson(data),
      );

  Future<void> sendLeague(ModelLeague league) async {
    await _service.setData(
      path: FirestorePath.leagues(league.id),
      data: league.toMap(),
    );
  }

  Future<void> sendMatch(ModelMatch match) async {
    await _service.setData(
      path: FirestorePath.match(match.idLeague, match.id),
      data: match.toJson(),
    );

   // sendCustomNotification("Se ha modificado un partido en el que participas", "Tenis 100 Match", match.idPlayer1);
   // sendCustomNotification("Se ha modificado un partido en el que participas", "Tenis 100 Match", match.idPlayer2);
  }

  Future<void> sendTournament(ModelLeague league) async {
    await _service.setData(
      path: FirestorePath.tournament(league.id),
      data: league.toMap(),
    );
  }

  Future<void> sendMatchTournament(ModelMatch match) async {
    await _service.setData(
      path: FirestorePath.matchTournament(match.idLeague, match.id),
      data: match.toJson(),
    );
   // sendCustomNotification("Se ha modificado un partido en el que participas", "Tenis 100 Match", match.idPlayer1);
    // sendCustomNotification("Se ha modificado un partido en el que participas", "Tenis 100 Match", match.idPlayer2);
  }

  Future<List<ModelLeague>> getLeaguesCollection() async {
    List<ModelLeague> leaguesToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.leaguesStream);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      leaguesToReturn.add(new ModelLeague.fromJson(obj));
    }
    return leaguesToReturn;
  }

  Future<List<ModelLeague>> getTournamentCollection() async {
    List<ModelLeague> leaguesToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.tournamentStream);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      leaguesToReturn.add(new ModelLeague.fromJson(obj));
    }
    return leaguesToReturn;
  }

  Stream<List<ModelMatch>> matchesStream(String idLeague) => _service.collectionStream(
        path: FirestorePath.matches(idLeague),
        builder: (data, documentId) => ModelMatch.fromJson(data),
        sort: (msg1, msg2) => msg1.week.compareTo(msg2.week),
      );

  Stream<List<ModelMatch>> matchesTournamentStream(String idLeague) => _service.collectionStream(
        path: FirestorePath.matchesTournament(idLeague),
        builder: (data, documentId) => ModelMatch.fromJson(data),
        sort: (msg1, msg2) => msg1.week.compareTo(msg2.week),
      );

  Future<List<ModelMatch>> getMatchesCollection(String idLeague) async {
    List<ModelMatch> matchesToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.matches(idLeague));
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      matchesToReturn.add(new ModelMatch.fromJson(obj));
    }
    return matchesToReturn;
  }

  Future<List<ModelMatch>> getMatchesTournamentCollection(String idLeague) async {
    List<ModelMatch> matchesToReturn = [];
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(FirestorePath.matchesTournament(idLeague));
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var obj in allData) {
      matchesToReturn.add(new ModelMatch.fromJson(obj));
    }

    matchesToReturn.sort((msg1, msg2) => msg1.week.compareTo(msg2.week));

    return matchesToReturn;
  }

  // Notifications
  void sendCustomNotification(String message, String title, String idUser) {
    ModelNotification notification = new ModelNotification(title: title, body: message, topic: idUser);
    FirebaseNotifications.sendPushMessage(notification);
  }
}
