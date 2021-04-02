import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ModelUserLeague extends Equatable {
  String id;
  String fullName;
  String email;
  String level;
  String image;
  int currentScore;

  ModelUserLeague({this.id, this.fullName, this.email, this.level, this.currentScore, this.image});

  factory ModelUserLeague.fromJson(Map<String, dynamic> json) => ModelUserLeague(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        level: json['level'] as String,
        currentScore: json['currentScore'] as int,
        image: json['image'] as String,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': this.id,
        'fullName': this.fullName,
        'email': this.email,
        'level': this.level,
        'image': this.image,
        'currentScore': this.currentScore,
      };


  @override
  String toString() {
    return 'ModelUserLeague{id: $id, fullName: $fullName, email: $email, level: $level, image: $image, currentScore: $currentScore}';
  }

  @override
  List<Object> get props => [id, fullName, email, level, image, currentScore];
}
