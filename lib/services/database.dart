import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/FirestorePaths.dart';

import 'firestore_service.dart';

class Database {
  Database({@required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> registerUser(ModelUserLeague userLeague) {
    userLeague.id = uid;
    _service.setData(path: FirestorePath.createUser(uid), data: userLeague.toMap());
  }

  Stream<List<ModelUserLeague>> userStream() => _service.collectionStream(
    path: FirestorePath.users,
    builder: (data, documentId) => ModelUserLeague.fromJson(data),
  );

  Future<List<ModelUserLeague>> getUserCollection() async {
    List<ModelUserLeague> usersToReturn = [];
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection(FirestorePath.users);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for ( var obj in allData){
      usersToReturn.add(new ModelUserLeague.fromJson(obj));
    }
    return usersToReturn;
  }


/*
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (final entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: FirestorePath.job(uid, job.id));
  }*/
}
