import 'package:equatable/equatable.dart';

class ModelComment extends Equatable {
  final String id;
  final String userId;
  final String comment;
  final DateTime createdAt;
  ModelComment({this.id, this.comment, this.createdAt, this.userId});

  factory ModelComment.fromJson(Map<String, dynamic> json) => ModelComment(
        id: json['id'] as String,
        comment: json['comment'] as String,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
        userId: json['userId'] as String,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': this.id,
      'userId': this.userId,
      'comment': this.comment,
      'createdAt': this.createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, userId, comment, createdAt];
}
