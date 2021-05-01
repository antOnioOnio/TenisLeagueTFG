import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';

import 'package:tenisleague100/services/GlobalMethods.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../top_providers.dart';

import 'dart:math' as math;

class DrawByLevel extends StatefulWidget {
  final List<ModelUserLeague> users;
  final String tournamentID;
  const DrawByLevel({Key key, @required this.users, @required this.tournamentID}) : super(key: key);

  @override
  _DrawByLevelState createState() => _DrawByLevelState();
}

class _DrawByLevelState extends State<DrawByLevel> {
  List<Widget> firstRound = [];
  List<Widget> secondRound = [];
  List<Widget> thirdRound = [];
  List<Widget> fourthRound = [];
  List<Widget> fithRound = [];
  List<ModelUserLeague> users;
  List<ModelMatch> matches = [];
  bool _isLoading;
  int lenghtUsersInTournament;
  int firstRoundLenght;
  @override
  void initState() {
    super.initState();
    users = widget.users;
    lenghtUsersInTournament = findLenght(widget.users.length);
    getMatches();
  }

  void getMatches() async {
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });

    this.matches = await database.getMatchesTournamentCollection(widget.tournamentID);
    firstRoundLenght = (matches.length + 1) ~/ 2;
    print("matches size==>" + matches.length.toString());
    initWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(top: 10),
      child: _isLoading ? circularLoadingBar() : mainDraw(),
    );
  }

  Widget mainDraw() {
    return this.matches.isEmpty ? createMatchesButton() : mainListUsers();
  }

  Widget mainListUsers() {
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Column(
                  children: firstRound,
                ),
                Column(
                  children: secondRound,
                ),
                Column(
                  children: thirdRound,
                ),
                Column(
                  children: fourthRound,
                ),
                Column(
                  children: fithRound,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget createMatchesButton() {
    print("createMatches");
    return Center(
      child: FlatButton(
        onPressed: () => {createMatches()},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.blueAccent,
        child: Text(
          "Create Matches",
          style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget customWidget(String user1, String user2) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 40,
          color: Colors.blueAccent,
          child: Text(user1),
        ),
        Container(
          width: 100,
          height: 40,
          color: Colors.red,
          child: Text(user2),
        ),
      ],
    );
  }

  /*1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16

  (1, 16),  (2, 15),  (3, 14),  (4, 13),   (5, 12),   (6, 11),   (7, 10),   (8, 9)

  (1, 16, 8, 9),  (2, 15, 7, 10),  (3, 14, 6, 11),  (4, 13, 5, 12)

  (1, 16, 8, 9, 4, 13, 5, 12),  (2, 15, 7, 10, 3, 14, 6, 11)*/
  void createMatches() async {
    print("createMatches called");
    final database = context.read<Database>(databaseProvider);
    for (int i = widget.users.length; i < lenghtUsersInTournament; i++) {
      users.add(new ModelUserLeague(fullName: "BYE", id: generateUuid()));
    }
    List<ModelUserLeague> list = users;

    int lenght = (list.length / 2).toInt();
    int iter = lenght;
    int slice = 1;
    while (slice < lenght) {
      List<ModelUserLeague> temp = list;
      Iterable iterable = temp.reversed;
      List<ModelUserLeague> listReversed = iterable.toList();
      list = [];

      for (int i = 0; i < iter; i++) {
        List<ModelUserLeague> subBeg = temp.sublist(0, slice);
        for (var obj in subBeg) temp.remove(obj);
        List<ModelUserLeague> subRev = listReversed.sublist(0, slice);
        for (var obj in subRev) listReversed.remove(obj);
        list.addAll(subBeg);
        list.addAll(subRev);
      }
      slice = slice * 2;
      iter = (iter / 2).toInt();
    }

    users = list;
    int week = 1;
    for (int i = 0; i < list.length; i = i + 2) {
/*      matches.add(new ModelMatch(
          id: generateUuid(), idLeague: generateUuid(), idPlayer1: users[i].id, idPlayer2: users[i + 1].id, played: false, week: week));*/
      ModelMatch match = new ModelMatch(
          id: generateUuid(), idLeague: widget.tournamentID, idPlayer1: users[i].id, idPlayer2: users[i + 1].id, played: false, week: week);
      await database.sendMatchTournament(match);
      week++;
    }
    firstRoundLenght = week;

    int lenghtRound = firstRoundLenght;
    while (lenghtRound != 1) {
      lenghtRound = lenghtRound ~/ 2;
      for (int i = 0; i < lenghtRound; i++) {
        ModelMatch match = new ModelMatch(id: generateUuid(), idLeague: widget.tournamentID, played: false, week: week);
        await database.sendMatchTournament(match);
      }
      week++;
    }
  }

  void initWidgets() {
    print("initWidget called with first round size=>" + firstRoundLenght.toString());
    for (var i = 0; i < firstRoundLenght; i++) {
      ModelUserLeague player1 = getUserFromList(users, matches[i].idPlayer1);
      ModelUserLeague player2 = getUserFromList(users, matches[i].idPlayer2);
      String result = getCompleteResult(matches[i].resultSet1, matches[i].resultSet2, matches[i].resultSet3);
      firstRound.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: drawDeco(),
          width: 90,
          height: 80,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  player1 != null ? player1.fullName : "BYE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                ),
              ),
              Container(
                decoration: resultDraw(),
                width: 50,
                child: Text(
                  matches[i].week.toString(),
                  style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  player2 != null ? player2.fullName : "BYE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    int roundSize = firstRoundLenght ~/ 2;
    int round = 2;
    int lastIndex = firstRoundLenght;
    while (roundSize != 0) {
      List<Widget> roundWidget = [];

      for (int i = lastIndex; i < lastIndex + roundSize; i++) {
        roundWidget.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Container(
                height: 40,
              ),
              Container(
                decoration: drawDeco(),
                width: 90,
                height: 80,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Player 1",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                      ),
                    ),
                    Container(
                      decoration: resultDraw(),
                      width: 50,
                      child: Text(i.toString()),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Player 2",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
              ),
            ],
          ),
        ));
      }
      if (round == 2) {
        secondRound = roundWidget;
        lastIndex = lastIndex + secondRound.length;
      } else if (round == 3) {
        thirdRound = roundWidget;
        lastIndex = lastIndex + thirdRound.length;
      }
      roundSize = roundSize ~/ 2;
      round++;
    }

    setState(() {
      _isLoading = false;
    });
  }
}
