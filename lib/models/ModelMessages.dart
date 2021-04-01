import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ModelMessage {
  final String idUser;
  final String idUserSendTo;
  final String image;
  final String userName;
  final String message;
  final DateTime createdAt;

  ModelMessage(
      {@required this.idUser,
      @required this.idUserSendTo,
      @required this.image,
      @required this.userName,
      @required this.message,
      @required this.createdAt});


  factory ModelMessage.fromJson(Map<String, dynamic> json) => ModelMessage(
        idUser: json['idUser'] as String,
        idUserSendTo: json['idUserSendTo'] as String,
        image: json['image'] as String,
        userName: json['userName'] as String,
        message: json['message'] as String,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'idUser': this.idUser,
        'idUserSendTo': this.idUserSendTo,
        'image': this.image,
        'userName': this.userName,
        'message': this.message,
        'createdAt': this.createdAt,
      };
}
