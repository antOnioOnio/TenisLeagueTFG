import 'package:json_annotation/json_annotation.dart';

part 'ModelUserLeague.g.dart';

@JsonSerializable(explicitToJson: true)
class ModelUserLeague {
  String id;
  String fullName;
  String email;
  String level;
  int currentScore;

  ModelUserLeague({this.id, this.fullName, this.email, this.level, this.currentScore});

  factory ModelUserLeague.fromJson(Map<String, dynamic> json) => _$ModelUserLeagueFromJson(json);

  Map<String, dynamic> toMap() => _$ModelUserLeagueToJson(this);

  @override
  String toString() {
    return 'ModelUserLeague{id: $id, fullName: $fullName, email: $email, level: $level, currentScore: $currentScore}';
  }
}
