import 'package:equatable/equatable.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/GlobalValues.dart';

// ignore: must_be_immutable
class ModelUserLeague extends Equatable {
  String id;
  String fullName;
  String email;
  String level;
  String tlf;
  String image;
  String role;
  int currentScore;
  int matchPlayed;
  int matchWins;
  int matchLosses;

  ModelUserLeague(
      {this.id, this.fullName, this.email, this.tlf, this.level, this.currentScore, this.image, this.role, this.matchLosses, this.matchPlayed, this.matchWins})
      : assert(level != GlobalValues.levelPrincipiante || level != GlobalValues.leveMedio || level != GlobalValues.levelAvanzado);

  factory ModelUserLeague.fromJson(Map<String, dynamic> json) => ModelUserLeague(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        level: json['level'] as String,
        tlf: json['tlf'] as String,
        currentScore: json['currentScore'] as int,
        matchPlayed: json['matchPlayed'] as int,
        matchWins: json['matchWins'] as int,
        matchLosses: json['matchLosses'] as int,
        image: json['image'] as String,
        role: json['role'] as String,
      );

  ModelUserLeague copyWithOneMoreMatch(bool win) {
    return ModelUserLeague(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      level: this.level,
      tlf: this.tlf,
      currentScore: win ? this.currentScore + 3 : this.currentScore,
      matchPlayed: this.matchPlayed + 1,
      matchWins: win ? this.matchWins + 1 : this.matchWins,
      matchLosses: win ? this.matchLosses : this.matchLosses + 1,
      image: this.image,
      role: this.role,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': this.id,
        'fullName': this.fullName,
        'email': this.email,
        'level': this.level,
        'tlf': this.tlf,
        'image': this.image,
        'currentScore': this.currentScore,
        'matchPlayed': this.matchPlayed,
        'matchWins': this.matchWins,
        'matchLosses': this.matchLosses,
        'role': this.role,
      };

  String get getFulleName => fullName != null ? fullName : "BYE";


  @override
  String toString() {
    return 'ModelUserLeague{id: $id, fullName: $fullName, email: $email, level: $level, tlf: $tlf, image: $image, role: $role, currentScore: $currentScore, matchPlayed: $matchPlayed, matchWins: $matchWins, matchLosses: $matchLosses}';
  }

  @override
  List<Object> get props => [id, fullName, email, level, tlf, image, currentScore, role];
}
