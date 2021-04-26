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

ModelUserLeague getUserFromList(List<ModelUserLeague> list, String id){
  for ( var obj in list){
    if(obj.id == id){
      return obj;
    }
  }
  return null;
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


/*
  void sendMatch() async {
    final database = context.read<Database>(databaseProvider);
    ModelMatch match = new ModelMatch(
        id: generateUuid(),
        idLeague: "8209fbb0-9a22-11eb-ae3f-c5f87e07e75b",
        idPlayer1: "pBIgiZJWQNhqp1H7UVqrO3fsAg42",
        idPlayer2: "Cgnl06Nhg0YVFoOIHnXokLaLgMl2",
        idPlayerWinner: "Cgnl06Nhg0YVFoOIHnXokLaLgMl2",
        played: true,
        dateMatch: DateTime.now());

    ModelUserLeague userWinner = await database.getUserById(match.idPlayerWinner);
    String idUserLost = match.idPlayer1 == match.idPlayerWinner ? match.idPlayer2 : match.idPlayer1;
    ModelUserLeague userLoser = await database.getUserById(idUserLost);

    print("STEP 1, get the user and this is his score ==> " + userWinner.currentScore.toString());
    userWinner = userWinner.copyWithOneMoreMatch(true);
    print("STEP 2, increase his score ==> " + userWinner.currentScore.toString());
    userLoser = userLoser.copyWithOneMoreMatch(false);

      await database.sendMatch(match);
    await database.setUser(userWinner);
       await database.setUser(userLoser);
  }*/