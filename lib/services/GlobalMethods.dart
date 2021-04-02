import 'package:uuid/uuid.dart';

String generateUuid() {
  var uuid = Uuid();
  // Generate a v1 (time-based) id
  return uuid.v1();
}