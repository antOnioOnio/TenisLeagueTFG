import 'package:flutter_test/flutter_test.dart';
import 'package:tenisleague100/models/ModelMatch.dart';

void main() {
  // From Json tests
  group('fromJson', () {

    test('ModelMatch with null data', () {
      expect(() => ModelMatch.fromJson(null), throwsA(isInstanceOf<StateError>()));
    });


    test('ModelMatch with all properties', () {
      DateTime date = DateTime.now();
      String dateTime = date.toString();
      final modelMatch = ModelMatch.fromJson({
        'id': 'idRandom',
        'idLeague': 'idLeague',
        'idPlayer1': 'idPlayer1',
        'idPlayer2': 'idPlayer2',
        'idPlayerWinner': 'idPlayerWinner',
        'played': true,
        'resultSet1': '6-2',
        'resultSet2': '6-2',
        'resultSet3': '2-6',
        'week': 1,
        'dateMatch': dateTime,
      });
      expect(
        modelMatch,
        ModelMatch(
            id: 'idRandom',
            idLeague: 'idLeague',
            idPlayer1: 'idPlayer1',
            idPlayer2: 'idPlayer2',
            idPlayerWinner: 'idPlayerWinner',
            resultSet1: '6-2',
            resultSet2: '6-2',
            resultSet3: '2-6',
            played: true,
            week: 1,
            dateMatch: date),
      );
    });
  });

  group('toMap', () {
    test('Valid json object', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);

      ModelMatch match = new        ModelMatch(
          id: 'idRandom',
          idLeague: 'idLeague',
          idPlayer1: 'idPlayer1',
          idPlayer2: 'idPlayer2',
          idPlayerWinner: 'idPlayerWinner',
          resultSet1: '6-2',
          resultSet2: '6-2',
          resultSet3: '2-6',
          played: true,
          week: 1,
          dateMatch: _selectedDateIndate);
      expect(match.toJson(), {
        'id': 'idRandom',
        'idLeague': 'idLeague',
        'idPlayer1': 'idPlayer1',
        'idPlayer2': 'idPlayer2',
        'idPlayerWinner': 'idPlayerWinner',
        'resultSet1': '6-2',
        'resultSet2': '6-2',
        'resultSet3': '2-6',
        'played': true,
        'week': 1,
        'dateMatch': _selectedDateIndate.toIso8601String(),
      });
    });
  });

  group('igualdad', () {
    test('Different properties == false', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);

      ModelMatch match = new        ModelMatch(
          id: 'idRandom',
          idLeague: 'idLeague',
          idPlayer1: 'idPlayer1',
          idPlayer2: 'idPlayer2',
          idPlayerWinner: 'idPlayerWinner',
          resultSet1: '6-2',
          resultSet2: '6-2',
          resultSet3: '7-5',
          played: true,
          week: 2,
          dateMatch: _selectedDateIndate);

      ModelMatch match2 = new        ModelMatch(
          id: 'idRandom',
          idLeague: 'idLeague',
          idPlayer1: 'idPlayer1',
          idPlayer2: 'idPlayer2',
          idPlayerWinner: 'idPlayerWinner',
          resultSet1: '6-2',
          resultSet2: '6-2',
          resultSet3: '2-6',
          played: true,
          week: 1,
          dateMatch: _selectedDateIndate);
      expect(match == match2, false);
    });

    test('same properties, equality returns true', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelMatch match = new        ModelMatch(
          id: 'idRandom',
          idLeague: 'idLeague',
          idPlayer1: 'idPlayer1',
          idPlayer2: 'idPlayer2',
          idPlayerWinner: 'idPlayerWinner',
          resultSet1: '6-2',
          resultSet2: '6-2',
          resultSet3: '7-5',
          played: true,
          week: 2,
          dateMatch: _selectedDateIndate);
      ModelMatch match1= new        ModelMatch(
          id: 'idRandom',
          idLeague: 'idLeague',
          idPlayer1: 'idPlayer1',
          idPlayer2: 'idPlayer2',
          idPlayerWinner: 'idPlayerWinner',
          resultSet1: '6-2',
          resultSet2: '6-2',
          resultSet3: '7-5',
          played: true,
          week: 2,
          dateMatch: _selectedDateIndate);
      expect(match == match1, true);
    });
  });

}
