import 'package:equatable/equatable.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

// ignore: must_be_immutable
class ModelUserLeague extends Equatable {
  String id;
  String fullName;
  String email;
  String level;
  String tlf;
  String image;
  int currentScore;

  ModelUserLeague({this.id, this.fullName, this.email,this.tlf, this.level, this.currentScore, this.image})
      : assert(level != GlobalValues.levelPrincipiante || level != GlobalValues.leveMedio ||  level != GlobalValues.levelAvanzado);


  factory ModelUserLeague.fromJson(Map<String, dynamic> json) => ModelUserLeague(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        level: json['level'] as String,
        tlf: json['tlf'] as String,
        currentScore: json['currentScore'] as int,
        image: json['image'] as String,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': this.id,
        'fullName': this.fullName,
        'email': this.email,
        'level': this.level,
        'tlf': this.tlf,
        'image': this.image,
        'currentScore': this.currentScore,
      };


  @override
  String toString() {
    return 'ModelUserLeague{id: $id, fullName: $fullName, email: $email, level: $level, tlf: $tlf, image: $image, currentScore: $currentScore}';
  }

  @override
  List<Object> get props => [id, fullName, email, level, tlf, image, currentScore];
}
