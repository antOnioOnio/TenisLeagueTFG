import 'package:flutter_test/flutter_test.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelMessages.dart';
import 'package:tenisleague100/models/ModelPlace.dart';

void main() {
  // From Json tests
  group('fromJson', () {

    test('ModelPlace with null data', () {
      expect(() => ModelPlace.fromJson(null), throwsA(isInstanceOf<StateError>()));
    });


    test('ModelPlace with all properties', () {
      DateTime date = DateTime.now();
      String dateTime = date.toString();
      final modelPlace = ModelPlace.fromJson({
        'id': 'idRandom',
        'name': 'name',
      });
      expect(
        modelPlace,
        ModelPlace(
            id: 'idRandom',
            name: 'name',),
      );
    });
  });

  group('toMap', () {
    test('Valid json object', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);

      ModelPlace model = new            ModelPlace(
          id: 'idRandom',
          name: 'idLeague',
      );
      expect(model.toMap(), {
        'id': 'idRandom',
        'name': 'idLeague',
      });
    });
  });

  group('igualdad', () {
    test('Different properties == false', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);

      ModelPlace model = new            ModelPlace(
        id: 'idRandom',
        name: 'idLeague',
      );

      ModelPlace model1 = new            ModelPlace(
        id: 'idRandom1',
        name: 'idLeague',
      );

      expect(model == model1, false);
    });

    test('same properties, equality returns true', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelPlace model1 = new            ModelPlace(
        id: 'idRandom1',
        name: 'idLeague',
      );

      ModelPlace model = new            ModelPlace(
        id: 'idRandom1',
        name: 'idLeague',
      );

      expect(model1 == model, true);
    });
  });

}
