import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/GlobalValues.dart';

class ModelLeague extends Equatable {
  final String id;
  final String level;
  final DateTime dateLeague;
  ModelLeague({@required this.id, @required this.level, @required this.dateLeague})
      : assert(level != GlobalValues.levelPrincipiante || level != GlobalValues.leveMedio || level != GlobalValues.levelAvanzado);

  factory ModelLeague.fromJson(Map<String, dynamic> json) => ModelLeague(
      id: json['id'] as String,
      level: json['level'] as String,
      dateLeague: json['dateLeague'] == null ? null : DateTime.parse(json['dateLeague'] as String));

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'level': this.level,
      'dateLeague': this.dateLeague?.toIso8601String(),
    };
  }
  @override
  List<Object> get props => [id, level, dateLeague];

  @override
  String toString() {
    return 'ModelLeague{id: $id, level: $level, dateLeague: $dateLeague}';
  }
}
