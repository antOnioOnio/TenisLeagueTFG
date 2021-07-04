import 'package:flutter_test/flutter_test.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelMessages.dart';

void main() {
  // From Json tests
  group('fromJson', () {

    test('ModelMatch with null data', () {
      expect(() => ModelMessage.fromJson(null), throwsA(isInstanceOf<StateError>()));
    });


    test('ModelMatch with all properties', () {
      DateTime date = DateTime.now();
      String dateTime = date.toString();
      final modelMatch = ModelMessage.fromJson({
        'idUser': 'idRandom',
        'idUserSendTo': 'idLeague',
        'image': 'idPlayer1',
        'userName': 'idPlayer2',
        'message': 'idPlayerWinner',
        'createdAt': dateTime,
      });
      expect(
        modelMatch,
        ModelMessage(
            idUser: 'idRandom',
            idUserSendTo: 'idLeague',
            image: 'idPlayer1',
            userName: 'idPlayer2',
            message: 'idPlayerWinner',
            createdAt: date),
      );
    });
  });

  group('toMap', () {
    test('Valid json object', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);

      ModelMessage model = new            ModelMessage(
          idUser: 'idRandom',
          idUserSendTo: 'idLeague',
          image: 'idPlayer1',
          userName: 'idPlayer2',
          message: 'idPlayerWinner',
          createdAt: _selectedDateIndate);
      expect(model.toMap(), {
        'idUser': 'idRandom',
        'idUserSendTo': 'idLeague',
        'image': 'idPlayer1',
        'userName': 'idPlayer2',
        'message': 'idPlayerWinner',
        'createdAt': _selectedDateIndate.toIso8601String(),
      });
    });
  });

  group('igualdad', () {
    test('Different properties == false', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);

      ModelMessage modelMessage = new      ModelMessage(
          idUser: 'idRandom',
          idUserSendTo: 'idLeague',
          image: 'idPlayer1',
          userName: 'idPlayer2',
          message: 'idPlayerWinner',
          createdAt: _selectedDateIndate);

      ModelMessage modelMessage1 = new      ModelMessage(
          idUser: 'idRandom',
          idUserSendTo: 'idLeague',
          image: 'idPlayer1',
          userName: 'idPlayer2',
          message: 'idPlayerWinner1',
          createdAt: _selectedDateIndate);

      expect(modelMessage == modelMessage1, false);
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
