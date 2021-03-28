import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ModelMessages.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory ModelMessage.fromJson(Map<String, dynamic> json) => _$ModelMessageFromJson(json);

  Map<String, dynamic> toMap() => _$ModelMessageToJson(this);
}
