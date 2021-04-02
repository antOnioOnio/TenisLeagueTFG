import 'package:equatable/equatable.dart';

class ModelComment extends Equatable {
  final String id;
  final String userId;
  final String comment;
  final DateTime createdAt;
  final String userImage;
  ModelComment({this.userImage, this.id, this.comment, this.createdAt, this.userId});

  factory ModelComment.fromJson(Map<String, dynamic> json) => ModelComment(
        id: json['id'] as String,
        comment: json['comment'] as String,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
        userId: json['userId'] as String,
        userImage: json['userImage'] as String,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': this.id,
      'userId': this.userId,
      'comment': this.comment,
      'userImage': this.userImage,
      'createdAt': this.createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, userId, comment, createdAt];
}
