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
  ModelUserLeague _currentUser;
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
    getMatches(false);
    getCurrentUser();
  }

  void getCurrentUser() async {
    final database = context.read<Database>(databaseProvider);
    _currentUser = await database.getCurrentUser();
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
        onPressed: () => {
          createMatches(),
        },
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

  Widget match(ModelMatch match, bool firstRound, int round) {
    ModelUserLeague player1 = getUserFromList(users, match.idPlayer1);
    ModelUserLeague player2 = getUserFromList(users, match.idPlayer2);
    String result = getCompleteResult(match.resultSet1, match.resultSet2, match.resultSet3);
    return GestureDetector(
      onTap: () => (player1.id == this._currentUser.id || player2.id == this._currentUser.id) && match.idPlayerWinner == null
          ? showDialogSetResult(context, match, player1, player2, true, findNextMatchAndUpdate)
          : DoNothingAction(),
      child: Column(
        children: [
          Container(
            height: ((round - 1) * 40).toDouble(),
          ),

          Container(
            decoration: drawDeco(),
            width: 90,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  player1 != null
                      ? player1.fullName
                      : firstRound
                          ? "BYE"
                          : "Por definir",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                ),
                Container(
                    width: 70,
                    height: 20,
                    child: Text(
                      result,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    )),
                Text(
                  player2 != null
                      ? player2.fullName
                      : firstRound
                          ? "BYE"
                          : "Por definir",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            height: ((round - 1) * 40).toDouble(),
          ),
        ],
      ),
    );
  }

  ModelMatch findNextMatch(ModelMatch match) {
    int sizeRound = (matches.length + 1) ~/ 2;
    int roundFound;
    int lastStart = 0;
    int round = 1;
    print("Match number==>" + match.week.toString());

    while (sizeRound != 0) {
      for (int i = lastStart; i < sizeRound + lastStart; i++) {
        if (i + 1 == match.week) {
          roundFound = round;
        }
      }
      if (round == 1) {
        lastStart = lastStart + firstRound.length;
      }
      if (round == 2) {
        lastStart = lastStart + secondRound.length;
      } else if (round == 3) {
        lastStart = lastStart + thirdRound.length;
      }
      sizeRound = sizeRound ~/ 2;
      round++;
    }

    int aux = match.week;
    int roundSize;
    int lastIndex;
    if (aux % 2 != 0) {
      aux++;
    }
    print("AUX==>" + aux.toString());

    if (roundFound == 1) {
      roundSize = firstRound.length;
      lastIndex = firstRoundLenght;
    }
    if (roundFound == 2) {
      roundSize = secondRound.length;
      lastIndex = firstRoundLenght + secondRound.length;
    } else if (roundFound == 3) {
      roundSize = thirdRound.length;
      lastIndex = firstRoundLenght + secondRound.length + thirdRound.length;
    }
    int toSumNextRound = aux ~/ 2 % (roundSize);
    int newIndex = lastIndex + toSumNextRound;
    print("new index ==> " + (newIndex - 1).toString());

    return matches[newIndex - 1];
  }

  /*1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16

  (1, 16),  (2, 15),  (3, 14),  (4, 13),   (5, 12),   (6, 11),   (7, 10),   (8, 9)

  (1, 16, 8, 9),  (2, 15, 7, 10),  (3, 14, 6, 11),  (4, 13, 5, 12)

  (1, 16, 8, 9, 4, 13, 5, 12),  (2, 15, 7, 10, 3, 14, 6, 11)*/
  void createMatches() async {
    print("createMatches called");
    setState(() {
      _isLoading = true;
    });
    final database = context.read<Database>(databaseProvider);
    for (int i = widget.users.length; i < lenghtUsersInTournament; i++) {
      users.add(new ModelUserLeague(fullName: "BYE", id: "BYE"));
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
        week++;
      }
    }

    setState(() {
      _isLoading = false;
    });
    getMatches(true);
  }

  void initWidgets() {
    firstRound.clear();
    secondRound.clear();
    thirdRound.clear();
    for (var i = 0; i < firstRoundLenght; i++) {
      firstRound.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: match(matches[i], true, 1),
      ));
    }

    int roundSize = firstRoundLenght ~/ 2;
    int round = 2;
    int lastIndex = firstRoundLenght;
    while (roundSize != 0) {
      List<Widget> roundWidget = [];
      for (int i = lastIndex; i < lastIndex + roundSize; i++) {
        roundWidget.add(
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: match(matches[i], false, round),
          ),
        );
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
  }

  void getMatches(bool checkForByesInMatches) async {
    print("get matches called");
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });

    this.matches = await database.getMatchesTournamentCollection(widget.tournamentID);
    firstRoundLenght = (matches.length + 1) ~/ 2;

    initWidgets();

    if (checkForByesInMatches) {
      checkForByes();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void checkForByes() async {
    final database = context.read<Database>(databaseProvider);
    print("checking for byes");
    for (var obj in matches) {
      if ((obj.idPlayer1 != "BYE" && obj.idPlayer2 == "BYE") || (obj.idPlayer2 != "BYE" && obj.idPlayer1 == "BYE")) {
        ModelMatch nexMatch = findNextMatch(obj);
        String idPlayerToMove = obj.idPlayer1 != "BYE" ? obj.idPlayer1 : obj.idPlayer2;
        ModelMatch updateMatch = nexMatch.copyWithNewPlayer(idPlayerToMove);
        await database.sendMatchTournament(updateMatch);
      }
    }
    getMatches(false);
  }

  void findNextMatchAndUpdate(ModelMatch match) async {
    setState(() {
      _isLoading = true;
    });
    print("findNextMatchAndUpdate called");
    final database = context.read<Database>(databaseProvider);
    ModelMatch nextMatch = findNextMatch(match);
    String idPlayerToMove = match.idPlayerWinner;
    ModelMatch updateMatch = nextMatch.copyWithNewPlayer(idPlayerToMove);
    await database.sendMatchTournament(updateMatch);
    getMatches(false);
    setState(() {
      _isLoading = false;
    });
  }
}
