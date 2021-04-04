import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ModelComment extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final DateTime createdAt;
  final String userImage;
  ModelComment(
      {@required this.userImage,
      @required this.userName,
      @required this.id,
      @required this.comment,
      @required this.createdAt,
      @required this.userId});

  factory ModelComment.fromJson(Map<String, dynamic> json) => ModelComment(
        id: json['id'] as String,
        comment: json['comment'] as String,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userImage: json['userImage'] as String,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': this.id,
      'userId': this.userId,
      'comment': this.comment,
      'userImage': this.userImage,
      'userName': this.userName,
      'createdAt': this.createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, userId, userName, comment, createdAt];

  @override
  String toString() {
    return 'ModelComment{id: $id, userId: $userId, userName: $userName, comment: $comment, createdAt: $createdAt, userImage: $userImage}';
  }
}
