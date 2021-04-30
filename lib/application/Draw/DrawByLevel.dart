import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';

import 'package:tenisleague100/services/GlobalMethods.dart';

import 'dart:math' as math;

class DrawByLevel extends StatefulWidget {
  final List<ModelUserLeague> users;
  const DrawByLevel({Key key, @required this.users}) : super(key: key);

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
  int lenghtTournament;
  @override
  void initState() {
    super.initState();
    users = widget.users;
    lenghtTournament = findLenght(widget.users.length);
    reOrderArraY();
    initWidgets();
  }

  /*1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16

  (1, 16),  (2, 15),  (3, 14),  (4, 13),   (5, 12),   (6, 11),   (7, 10),   (8, 9)

  (1, 16, 8, 9),  (2, 15, 7, 10),  (3, 14, 6, 11),  (4, 13, 5, 12)

  (1, 16, 8, 9, 4, 13, 5, 12),  (2, 15, 7, 10, 3, 14, 6, 11)*/
  void reOrderArraY() {
    for (int i = widget.users.length; i < 16; i++) {
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
    for (int i = 0; i < list.length; i = i + 2) {
      matches.add(
          new ModelMatch(id: generateUuid(), idLeague: generateUuid(), idPlayer1: users[i].id, idPlayer2: users[i + 1].id, played: false, week: 0));
    }
  }

  void initWidgets() {
    setState(() {
      _isLoading = true;
    });

    for (var i = 0; i < matches.length; i++) {
      ModelUserLeague player1 = getUserFromList(users, matches[i].idPlayer1);
      ModelUserLeague player2 = getUserFromList(users, matches[i].idPlayer2);
      /*  String result = matches[i].getResultSet1*/
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
                  player1.fullName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                ),
              ),
              Container(
                decoration: resultDraw(),
                width: 50,
                child: Text(""),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  player2.fullName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    for (int i = 0; i < matches.length / 2; i++) {
      secondRound.add(Padding(
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
                    child: Text(""),
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

    if (matches.length / 4 >= 1) {
      print("matches / 4 " + (matches.length / 4).toString());
      for (int i = 0; i < matches.length / 4; i++) {
        print("i==> " + i.toString());
        thirdRound.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 120,
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
                          child: Text(""),
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
                    height: 120,
                  ),
                ],
              ),
            ],
          ),
        ));
      }
    }

    if (matches.length / 8 >= 1) {
      for (int i = 0; i < matches.length / 8; i++) {
        fourthRound.add(Padding(
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
                    "Player 1",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(fontWeight: FontWeight.normal, fontSize: 10),
                  ),
                ),
                Container(
                  decoration: resultDraw(),
                  width: 50,
                  child: Text(""),
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
        ));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(top: 10),
      child: _isLoading ? circularLoadingBar() : mainListUsers(),
      /* child: Text("somehit"),*/
    );
  }

  Widget mainListUsers() {
    return SingleChildScrollView(
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
}
