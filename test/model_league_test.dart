import 'package:flutter_test/flutter_test.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/services/GlobalValues.dart';

void main() {
  // From Json tests
  group('fromJson', () {

    test('Model league with null data', () {
      expect(() => ModelLeague.fromJson(null), throwsA(isInstanceOf<StateError>()));
    });

    test('Model league with all properties', () {
      DateTime date = DateTime.now();
      String dateTime = date.toString();

      ModelLeague model = ModelLeague.fromJson({
        'id': 'idRandom',
        'level': GlobalValues.levelPrincipiante,
        'dateLeague': dateTime,
      });
      expect(
        model,
        ModelLeague(
            id: 'idRandom',
            level: GlobalValues.levelPrincipiante,
            dateLeague: date),
      );
    });
  });

  group('toMap', () {
    test('Valid json object', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelLeague model = ModelLeague(
          id: 'idRandom',
          level: GlobalValues.levelPrincipiante,
          dateLeague: _selectedDateIndate)  ;
      expect(model.toMap(), {
            'id': 'idRandom',
            'level': GlobalValues.levelPrincipiante,
            'dateLeague': _selectedDateIndate.toIso8601String(),
      });
    });
  });

  group('igualdad', () {

    test('Different properties == false', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelLeague model = ModelLeague(
          id: 'idRandom',
          level: GlobalValues.levelPrincipiante,
          dateLeague: _selectedDateIndate);
      ModelLeague model1 = ModelLeague(
          id: 'idRandom',
          level: GlobalValues.levelAvanzado,
          dateLeague: _selectedDateIndate);
      expect(model == model1, false);
    });
    test('same properties, equality returns true', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelLeague model = ModelLeague(
          id: 'idRandom',
          level: GlobalValues.levelPrincipiante,
          dateLeague: _selectedDateIndate);
      ModelLeague model1 = ModelLeague(
          id: 'idRandom',
          level: GlobalValues.levelPrincipiante,
          dateLeague: _selectedDateIndate);
      expect(model == model1, true);
    });
  });

}
