import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ModelMatch extends Equatable {
  final String id;
  final String idLeague;
  final String idPlayer1;
  final String idPlayer2;
  final String idPlayerWinner;
  final bool played;
  final String resultSet1;
  final String resultSet2;
  final String resultSet3;
  final DateTime dateMatch;
  final int week;

  ModelMatch(
      {@required this.id,
      @required this.idLeague,
      @required this.idPlayer1,
      @required this.idPlayer2,
      this.idPlayerWinner,
      @required this.played,
      this.resultSet1,
      this.resultSet2,
      this.resultSet3,
      this.dateMatch,
      @required this.week});

  ModelMatch copyWith(String idPlayerWinner, String resultSet1, String resultSet2, String resultSet3, DateTime date) {
    return new ModelMatch(
        id: this.id,
        idPlayerWinner: idPlayerWinner,
        resultSet1: resultSet1,
        resultSet2: resultSet2,
        resultSet3: resultSet3,
        dateMatch: date,
        idLeague: this.idLeague,
        idPlayer1: this.idPlayer1,
        idPlayer2: this.idPlayer2,
        played: true,
        week: this.week);
  }
  ModelMatch copyWithNewPlayer(String idNewPlayer) {
    String player1;
    String player2;
    if(idPlayer1==null){
      player1 = idNewPlayer;
    }else{
      player2 = idNewPlayer;
    }
    return new ModelMatch(
        id: this.id,
        idPlayerWinner: idPlayerWinner,
        resultSet1: resultSet1,
        resultSet2: resultSet2,
        resultSet3: resultSet3,
        dateMatch: dateMatch,
        idLeague: this.idLeague,
        idPlayer1: player1,
        idPlayer2: player2,
        played: true,
        week: this.week);
  }


  factory ModelMatch.fromJson(Map<String, dynamic> json) => ModelMatch(
      id: json['id'] as String,
      idLeague: json['idLeague'] as String,
      idPlayer1: json['idPlayer1'] as String,
      idPlayer2: json['idPlayer2'] as String,
      idPlayerWinner: json['idPlayerWinner'] as String,
      played: json['played'] as bool,
      resultSet1: json['resultSet1'] as String,
      resultSet2: json['resultSet2'] as String,
      resultSet3: json['resultSet3'] as String,
      week: json['week'] as int,
      dateMatch: json['dateMatch'] == null ? null : DateTime.parse(json['dateMatch'] as String));

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': this.id,
      'idLeague': this.idLeague,
      'idPlayer1': this.idPlayer1,
      'idPlayer2': this.idPlayer2,
      'idPlayerWinner': this.idPlayerWinner,
      'played': this.played,
      'resultSet1': this.resultSet1,
      'resultSet2': this.resultSet2,
      'resultSet3': this.resultSet3,
      'week': this.week,
      'dateMatch': this.dateMatch?.toIso8601String(),
    };
  }


  String get getResultSet1 => resultSet1 != null ? resultSet1 : "";
  String get getResultSet2 => resultSet2 != null ? resultSet2 : "";
  String get getResultSet3 => resultSet3 != null ? resultSet3 : "";
  String get getPlayerWinner => idPlayerWinner != null ? idPlayerWinner : "";
  @override
  List<Object> get props => [id, idLeague, idPlayer1, idPlayer2, idPlayerWinner, played, resultSet1, resultSet2, resultSet3, week, dateMatch];

  @override
  String toString() {
    return 'ModelMatch{id: $id, idLeague: $idLeague, idPlayer1: $idPlayer1, idPlayer2: $idPlayer2, idPlayerWinner: $idPlayerWinner, played: $played, resultSet1: $resultSet1, resultSet2: $resultSet2, resultSet3: $resultSet3, dateMatch: $dateMatch, week: $week}';
  }
}
