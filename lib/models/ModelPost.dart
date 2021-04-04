import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tenisleague100/models/ModelComment.dart';

part 'ModelPost.g.dart';

@JsonSerializable()
class ModelPost extends Equatable {
  final String id;
  final String idUser;
  final String nameOfUser;
  final String content;
  final String imageUser;
  final String image;
  final String postType;
  final DateTime createdAt;

  static const String typeProPMatch = "propMatch";
  static const String typePicture = "picture";
  static const String typeEvent = "event";
  static const String matchResult = "matchResult";

  ModelPost(
      {@required this.id,
      @required this.idUser,
      @required this.nameOfUser,
      @required this.content,
      @required this.imageUser,
      this.image,
      @required this.postType,
      @required this.createdAt,})
      : assert(postType != typeProPMatch || postType != typePicture || postType != typeEvent || postType != matchResult);

  factory ModelPost.fromJson(Map<String, dynamic> json) => _$ModelPostFromJson(json);

  Map<String, dynamic> toMap() => _$ModelPostToJson(this);

  @override
  String toString() {
    return 'ModelPost{id: $id, idUser: $idUser, nameOfUser: $nameOfUser, content: $content, imageUser: $imageUser, image: $image, postType: ' +
        postType.toString() +
        ', createdAt: $createdAt}';
  }

  @override
  List<Object> get props => [id, idUser, nameOfUser, content, imageUser, image, postType, createdAt];
}
