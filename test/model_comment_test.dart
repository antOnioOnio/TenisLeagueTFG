import 'package:flutter_test/flutter_test.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelMatch.dart';

void main() {
  // From Json tests
  group('fromJson', () {

    test('ModelComment with null data', () {
      expect(() => ModelComment.fromJson(null), throwsA(isInstanceOf<StateError>()));
    });



    test('ModelComment with all properties', () {
      DateTime date = DateTime.now();
      String dateTime = date.toString();
      final modelComment = ModelComment.fromJson({
        'id': 'idRandom',
        'comment': 'this is a comment',
        'createdAt': dateTime,
        'userId': 'randomId',
        'userName': 'antonio',
        'userImage': 'ssfsfsfsfsf',
      });
      expect(
        modelComment,
        ModelComment(
            userImage: 'ssfsfsfsfsf', userName: 'antonio', id: 'idRandom', comment: 'this is a comment', createdAt: date, userId: 'randomId'),
      );
    });
  });

  group('toMap', () {
    test('Valid json object', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      var comment = ModelComment(userImage: 'userImage', userName: 'userName', id: 'id', comment: 'comment', createdAt: _selectedDateIndate, userId: 'userId');
      expect(comment.toJson(), {
        'id': 'id',
        'userId': 'userId',
        'comment': 'comment',
        'userImage': 'userImage',
        'userName': 'userName',
        'createdAt': _selectedDateIndate.toIso8601String(),
      });
    });
  });

  group('igualdad', () {

    test('Different properties == false', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelComment comment1 = ModelComment(userImage: 'userImage', userName: 'userName', id: 'id', comment: 'comment', createdAt: _selectedDateIndate, userId: 'userId');
      ModelComment comment2 = ModelComment(userImage: 'userImage', userName: 'userName', id: 'id', comment: 'different commentario', createdAt: _selectedDateIndate, userId: 'userId');

      expect(comment1 == comment2, false);
    });
    test('same properties, equality returns true', () {
      DateTime now = DateTime.now();
      DateTime _selectedDateIndate = DateTime(now.year, now.month, now.day);
      ModelComment comment1 = ModelComment(userImage: 'userImage', userName: 'userName', id: 'id', comment: 'comment', createdAt: _selectedDateIndate, userId: 'userId');
      ModelComment comment2 = ModelComment(userImage: 'userImage', userName: 'userName', id: 'id', comment: 'comment', createdAt: _selectedDateIndate, userId: 'userId');

      expect(comment1 == comment2, true);
    });
  });

}
