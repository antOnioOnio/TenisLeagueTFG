import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
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


List<ModelMatch> matchesByWeek(List<ModelMatch> matches, int Week) {
  return matches.where((element) => element.week == Week).toList();
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

bool isPowerOfTwo(int x) {
  return (x & (x - 1)) == 0;
}

int findLenght(int i) {
  int lenght = i;
  if (isPowerOfTwo(lenght)) {
    return lenght;
  } else {
    while (true) {
      lenght++;
      if (isPowerOfTwo(lenght)) {
        return lenght;
      }
    }
  }
}

String getCompleteResult(String set1, String set2, String set3){
  if(set1 != null && set2 != null){
    String result = set1 + " " + set2;
    if(set3!= null){
      result += " " + set3;
    }
  }else {
    return "";
  }
}


