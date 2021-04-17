import 'package:flutter/material.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../top_providers.dart';

class MainCalendar extends StatefulWidget {
  @override
  _MainCalendarState createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          basicScreenColorChatBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [TextButton(onPressed: () => /*sendMatch()*/ print("something"), child: Text("click here broda"))],
              ),
            ),
          )
        ],
      ),
    );
  }

/*  void sendMatch() async {
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

    */ /* await database.sendMatch(match);*/ /*
    await database.setUser(userWinner);
    */ /*  await database.setUser(userLoser);*/ /*
  }*/
}
