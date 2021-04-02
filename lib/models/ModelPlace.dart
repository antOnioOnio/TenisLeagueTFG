import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ModelPlace extends Equatable {
  final String id;
  final String name;

  ModelPlace({@required this.id, @required this.name});

  factory ModelPlace.fromJson(Map<String, dynamic> json) => ModelPlace(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
    };
  }

  @override
  String toString() {
    return 'ModelPlace{id: $id, name: $name}';
  }

  @override
  List<Object> get props => [id, name];
}
