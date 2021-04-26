// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModelPost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelPost _$ModelPostFromJson(Map<String, dynamic> json) {
  return ModelPost(
    id: json['id'] as String,
    idUser: json['idUser'] as String,
    nameOfUser: json['nameOfUser'] as String,
    content: json['content'] as String,
    imageUser: json['imageUser'] as String,
    image: json['image'] as String,
    postType: json['postType'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$ModelPostToJson(ModelPost instance) => <String, dynamic>{
      'id': instance.id,
      'idUser': instance.idUser,
      'nameOfUser': instance.nameOfUser,
      'content': instance.content,
      'imageUser': instance.imageUser,
      'image': instance.image,
      'postType': instance.postType,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
