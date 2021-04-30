import 'package:flutter/material.dart';
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
  List<Widget> widgets = [];
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
    for (int i = widget.users.length; i < lenghtTournament; i++) {
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
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            new Container(width: 100, height: 30, color: Colors.green, child: Text(player1.fullName)),
            new Container(width: 100, height: 30, color: Colors.green, child: Text(player2.fullName)),
          ],
        ),
      ));
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
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Column(
            children: widgets,
          ),
        ],
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
