import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:uuid/uuid.dart';

String generateUuid() {
  var uuid = Uuid();
  // Generate a v1 (time-based) id
  return uuid.v1();
}


List<ModelUserLeague> userByLevel(List<ModelUserLeague> users, String level) {
  return users.where((element) => element.level == level).toList();
}

String leagueId( List<ModelLeague> leagues, String level){
  for(var obj in leagues){
    if(obj.level == level){
      return obj.id;
    }
  }
  return "";
}

/*  void sendLeague() {
    final database = context.read<Database>(databaseProvider);
    //ModelLeague league = new ModelLeague(id: generateUuid(), level: GlobalValues.levelPrincipiante, dateLeague: DateTime.now());
    ModelMatch match = new ModelMatch(
        id: generateUuid(),
        idLeague: "8209fbb0-9a22-11eb-ae3f-c5f87e07e75b",
        idPlayer1: generateUuid(),
        idPlayer2: generateUuid(),
        played: true,
        dateMatch: DateTime.now());

    database.sendMatch(match);
  }*/