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
  int matchPlayed;
  int matchWins;
  int matchLosses;

  ModelUserLeague(
      {this.id, this.fullName, this.email, this.tlf, this.level, this.currentScore, this.image, this.matchLosses, this.matchPlayed, this.matchWins})
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
      };

  @override
  String toString() {
    return 'ModelUserLeague{id: $id, fullName: $fullName, email: $email, level: $level, tlf: $tlf,  currentScore: $currentScore, matchPlayed: $matchPlayed, matchWins: $matchWins, matchLosses: $matchLosses}';
  }

  @override
  List<Object> get props => [id, fullName, email, level, tlf, image, currentScore];
}
