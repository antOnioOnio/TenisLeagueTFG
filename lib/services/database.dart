
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/FirestorePaths.dart';

import 'firestore_service.dart';

class Database {
  Database({@required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> registerUser(ModelUserLeague userLeague) => _service.setData(
    path: FirestorePath.createUser(uid),
    data: userLeague.toMap()
  );

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
