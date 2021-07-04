import 'package:flutter_test/flutter_test.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelMessages.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/GlobalValues.dart';

void main() {
  // From Json tests
  group('fromJson', () {

    test('ModelUserLeague with null data', () {
      expect(() => ModelUserLeague.fromJson(null), throwsA(isInstanceOf<StateError>()));
    });

    test('ModelUserLeague with all properties', () {
      DateTime date = DateTime.now();
      String dateTime = date.toString();
      final modelUser = ModelUserLeague.fromJson({
        'id': 'idRandom',
        'fullName': 'idLeague',
        'email': 'idPlayer1',
        'level': GlobalValues.levelPrincipiante,
        'tlf': 'idPlayerWinner',
        'image': 'dateTime',
        'role': 'dateTime',
        'currentScore': 1,
        'matchPlayed': 1,
        'matchWins': 1,
        'matchLosses': 1,
      });
      expect(
        modelUser,
        ModelUserLeague(
            id: 'idRandom',
            fullName: 'idLeague',
            email: 'idPlayer1',
            level: GlobalValues.levelPrincipiante,
            tlf: 'idPlayerWinner',
            image: 'dateTime',
            role: 'dateTime',
            currentScore: 1,
            matchPlayed: 1,
            matchWins: 1,
            matchLosses: 1),
      );
    });
  });

  group('toMap', () {
    test('Valid json object', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);

     ModelUserLeague user =  ModelUserLeague(
          id: 'idRandom',
          fullName: 'idLeague',
          email: 'idPlayer1',
          level: GlobalValues.levelPrincipiante,
          tlf: 'idPlayerWinner',
          image: 'dateTime',
          role: 'dateTime',
          currentScore: 1,
          matchPlayed: 1,
          matchWins: 1,
          matchLosses: 1);
      expect(user.toMap(), {
        'id': 'idRandom',
        'fullName': 'idLeague',
        'email': 'idPlayer1',
        'level': GlobalValues.levelPrincipiante,
        'tlf': 'idPlayerWinner',
        'image': 'dateTime',
        'role': 'dateTime',
        'currentScore': 1,
        'matchPlayed': 1,
        'matchWins': 1,
        'matchLosses': 1,
      });
    });
  });

  group('igualdad', () {
    test('Different properties == false', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);


      ModelUserLeague user =  ModelUserLeague(
          id: 'idRandom',
          fullName: 'idLeague',
          email: 'idPlayer1',
          level: GlobalValues.levelPrincipiante,
          tlf: 'idPlayerWinner',
          image: 'dateTime',
          role: 'dateTime',
          currentScore: 2,
          matchPlayed: 1,
          matchWins: 1,
          matchLosses: 1);


      ModelUserLeague user1 =  ModelUserLeague(
          id: 'idRandom',
          fullName: 'idLeague',
          email: 'idPlayer1',
          level: GlobalValues.levelPrincipiante,
          tlf: 'idPlayerWinner',
          image: 'dateTime',
          role: 'dateTime',
          currentScore: 1,
          matchPlayed: 1,
          matchWins: 1,
          matchLosses: 1);

      expect(user == user1, false);
    });

    test('same properties, equality returns true', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelMessage modelMessage1 = new      ModelMessage(
          idUser: 'idRandom',
          idUserSendTo: 'idLeague',
          image: 'idPlayer1',
          userName: 'idPlayer2',
          message: 'idPlayerWinner1',
          createdAt: _selectedDateIndate);

      ModelMessage modelMessage2 = new      ModelMessage(
          idUser: 'idRandom',
          idUserSendTo: 'idLeague',
          image: 'idPlayer1',
          userName: 'idPlayer2',
          message: 'idPlayerWinner1',
          createdAt: _selectedDateIndate);

      expect(modelMessage1 == modelMessage2, true);
    });
  });

}
