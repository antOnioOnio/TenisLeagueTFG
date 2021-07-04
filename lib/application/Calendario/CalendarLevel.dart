import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenisleague100/services/GlobalValues.dart';

import '../top_providers.dart';

class CalendarByLevel extends StatefulWidget {
  final String leagueId;
  final List<ModelUserLeague> users;
  final bool justMyMatches;
  const CalendarByLevel({Key key, @required this.leagueId, @required this.users, @required this.justMyMatches}) : super(key: key);
  @override
  _CalendarByLevelState createState() => _CalendarByLevelState();
}

class _CalendarByLevelState extends State<CalendarByLevel> {
  List<int> _weeks = [];
  List<ModelMatch> _matches = [];
  ModelUserLeague _currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  void getCurrentUserId() async {
    final database = context.read<Database>(databaseProvider);
    _currentUser = await database.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(top: 10),
      child: _mainCalendarWidget(),
    );
  }

  Widget _mainCalendarWidget() {
    final database = context.read<Database>(databaseProvider);
    return widget.leagueId != ""
        ? StreamBuilder<List<ModelMatch>>(
            stream: database.matchesStream(widget.leagueId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return circularLoadingBar();
                default:
                  if (snapshot.hasError) {
                    return circularLoadingBar();
                  } else {
                    final matches = snapshot.data;
                    return matches.isEmpty
                        ? _currentUser.role == "admin"
                            ? createMatchesButton()
                            : Center(
                                child: Text(
                                  "No hay partidos aún",
                                  style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              )
                        : listWeeks(matches);
                  }
              }
            },
          )
        : createMatchesButton();
  }

  Widget listWeeks(List<ModelMatch> matches) {
    _matches = matches;
    initWeeks(_matches[_matches.length - 1].week);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: _weeks.length,
      itemBuilder: (context, index) {
        return _weekNumberWidget(_weeks[index]);
      },
    );
  }

  Widget _weekNumberWidget(int numberWeek) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "SEMANA " + numberWeek.toString(),
            style: GoogleFonts.raleway(color: Color(GlobalValues.mainGreen), fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Divider(
          height: 1,
          color: Color(GlobalValues.mainTextColorHint),
        ),
        listMatches(
          matchesByWeek(_matches, numberWeek),
        ),
      ],
    );
  }

  Widget listMatches(List<ModelMatch> matches) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      reverse: false,
      shrinkWrap: true,
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return match(matches[index]);
      },
    );
  }

  void initWeeks(int maximWeek) {
    _weeks.clear();
    for (int i = 0; i < maximWeek; i++) {
      this._weeks.add(i + 1);
    }
  }

  Widget match(ModelMatch match) {
    ModelUserLeague user1 = getUserFromList(widget.users, match.idPlayer1);
    ModelUserLeague user2 = getUserFromList(widget.users, match.idPlayer2);
    Color colorFirstCell = match.getPlayerWinner == user1.id ? Colors.green[100] : Colors.white;
    Color colorSecondtCell = match.getPlayerWinner == user2.id ? Colors.green[100] : Colors.white;
    return Visibility(
      visible: getVisibilityForMatch(match),
      child: Column(
        children: [
          Container(
            height: 35,
            child: GestureDetector(
              onTap: () => (user1.id == this._currentUser.id || user2.id == this._currentUser.id || this._currentUser.role == "admin") &&
                      match.idPlayerWinner == null
                  ? showDialogSetResult(context, match, user1, user2, false, null)
                  : DoNothingAction(),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: colorFirstCell,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.sports_baseball_rounded,
                              size: 10,
                              color: Color(GlobalValues.mainGreen),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                user1.fullName,
                                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: decWeekMatch(colorSecondtCell),
                      child: Center(
                        child: Text(
                          user2.fullName,
                          style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                      ),
                      /* color: Colors.red,*/
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: decWeekMatch(Colors.white),
                      child: Center(
                        child: Text(
                          match.getResultSet1 + "  " + match.getResultSet2 + "  " + match.getResultSet3,
                          style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      /* color: Colors.red,*/
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Color(GlobalValues.mainTextColorHint),
          )
        ],
      ),
    );
  }

  Widget createMatchesButton() {
    return Center(
      child: FlatButton(
        onPressed: () => {_createMatches()},
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

  bool getVisibilityForMatch(ModelMatch match) {
    if (widget.justMyMatches && (match.idPlayer1 == _currentUser.id || match.idPlayer2 == _currentUser.id)) {
      return true;
    } else if (!widget.justMyMatches) {
      return true;
    }
    return false;
  }

  void _createMatches() async {
    final database = context.read<Database>(databaseProvider);
    List<ModelUserLeague> listTeam = widget.users;
    if (listTeam.length % 2 != 0) {
      ModelUserLeague user = new ModelUserLeague(fullName: "BYE");
      listTeam.add(user); // If odd number of teams add a dummy
    }

    int numDays = (listTeam.length - 1); // Days needed to complete tournament
    int halfSize = listTeam.length ~/ 2;

    List<ModelUserLeague> teams = [];

    teams.addAll(listTeam); // Add teams to List and remove the first team
    teams.removeAt(0);

    int teamsSize = teams.length;

    for (int day = 0; day < numDays; day++) {
      print("\n\nDAY ==> " + (day + 1).toString());
      int teamIdx = day % teamsSize;

      if (teams[teamIdx].fullName != "BYE") {
        ModelMatch match = new ModelMatch(
            id: generateUuid(), idLeague: widget.leagueId, idPlayer1: teams[teamIdx].id, idPlayer2: listTeam[0].id, played: false, week: day + 1);
        await database.sendMatch(match);
      }

      for (int idx = 1; idx < halfSize; idx++) {
        int firstTeam = (day + idx) % teamsSize;
        int secondTeam = (day + teamsSize - idx) % teamsSize;
        if (teams[firstTeam].fullName != "BYE" && teams[secondTeam].fullName != "BYE") {
          ModelMatch match = new ModelMatch(
              id: generateUuid(),
              idLeague: widget.leagueId,
              idPlayer1: teams[firstTeam].id,
              idPlayer2: teams[secondTeam].id,
              played: false,
              week: day + 1);
          await database.sendMatch(match);
        }
      }
    }
  }
}
