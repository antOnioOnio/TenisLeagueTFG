
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  Database({@required this.uid});
  final String uid;

  final _service = FirebaseFirestore.instance;


/*  Future<void> setJob(Job job) => _service.setData(
    path: FirestorePath.job(uid, job.id),
    data: job.toMap(),
  );

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
