import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import '../top_providers.dart';

class MainCalendar extends StatefulWidget {
  @override
  _MainCalendarState createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  List<ModelLeague> _currentLeagues = [];
  List<ModelUserLeague> _users = [];
  bool _isLoading;
  String _levelPrincipianteId = "";
  String _levelMedioId = "";
  String _levelAvanzadoId = "";
  @override
  void initState() {
    super.initState();
    getLeaguesAndUsers();
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
              child: _isLoading
                  ? circularLoadingBar()
                  : DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          headerTabBar(context),
                          pages(),
                        ],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget pages() {
    return Expanded(
      child: TabBarView(
        children: [
          Container(
            color: Colors.blueAccent,
          ),
          CalendarByLevel(
            leagueId: this._levelPrincipianteId,
            users: userByLevel(_users, GlobalValues.levelPrincipiante),
          ),
          CalendarByLevel(
            leagueId: this._levelMedioId,
            users: userByLevel(_users, GlobalValues.leveMedio),
          ),
          CalendarByLevel(
            leagueId: this._levelAvanzadoId,
            users: userByLevel(_users, GlobalValues.levelAvanzado),
          ),
        ],
      ),
    );
  }

  Widget headerTabBar(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TabBar(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: Color(GlobalValues.mainGreen)),
          insets: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        labelColor: Color(GlobalValues.mainGreen),
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontSize: 11),
        tabs: [
          Tab(
            text: "Mis Partidos",
          ),
          Tab(
            text: "Principiante",
          ),
          Tab(
            text: "Medio",
          ),
          Tab(
            text: "Avanzado",
          ),
        ],
      ),
    );
  }

  void getLeaguesAndUsers() async {
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });
    _currentLeagues = await database.getLeaguesCollection();
    for (var league in _currentLeagues) {
      if (league.level == GlobalValues.levelPrincipiante) {
        this._levelPrincipianteId = league.id;
      } else if (league.level == GlobalValues.levelAvanzado) {
        this._levelAvanzadoId = league.id;
      } else if (league.level == GlobalValues.leveMedio) {
        this._levelMedioId = league.id;
      }
    }
    _users = await database.getUserCollection();
    setState(() {
      _isLoading = false;
    });
  }
}

class CalendarByLevel extends StatefulWidget {
  final String leagueId;
  final List<ModelUserLeague> users;
  const CalendarByLevel({Key key, @required this.leagueId, @required this.users}) : super(key: key);
  @override
  _CalendarByLevelState createState() => _CalendarByLevelState();
}

class _CalendarByLevelState extends State<CalendarByLevel> {
  @override
  void initState() {
    super.initState();
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
                    print("there is an error");
                    return circularLoadingBar();
                  } else {
                    final matches = snapshot.data;
                    return matches.isEmpty
                        /* ? Center(child: Text("No hay partidos.."))*/
                        ? createMatchesButton()
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            reverse: false,
                            itemCount: matches.length,
                            itemBuilder: (context, index) {
                              return match(matches[index]);
                            },
                          );
                  }
              }
            },
          )
        : /*Center(child: Text("No hay partidos.."));*/ createMatchesButton();
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

  Widget match(ModelMatch match) {
    ModelUserLeague user1 = getUserFromList(widget.users, match.idPlayer1);
    ModelUserLeague user2 = getUserFromList(widget.users, match.idPlayer2);
    return Text(user1.fullName + " vs " + user2.fullName + "===> " + match.week.toString());
  }

  void _createMatches() async {
    final database = context.read<Database>(databaseProvider);
    List<ModelUserLeague> listTeam = widget.users;
    if (listTeam.length % 2 != 0) {
      ModelUserLeague user = new ModelUserLeague(fullName: "BYE");
      listTeam.add(user); // If odd number of teams add a dummy
    }

    int numDays = (listTeam.length - 1); // Days needed to complete tournament
    int halfSize = (listTeam.length / 2).toInt();

    List<ModelUserLeague> teams = [];

    teams.addAll(listTeam); // Add teams to List and remove the first team
    teams.removeAt(0);

    int teamsSize = teams.length;

    for (int day = 0; day < numDays; day++) {
      print("\n\nDAY ==> " + (day + 1).toString());
      int teamIdx = day % teamsSize;

      print(teams[teamIdx].fullName.toString() + "<==>" + listTeam[0].fullName.toString());

      if (teams[teamIdx].fullName != "BYE") {
        ModelMatch match = new ModelMatch(
            id: generateUuid(), idLeague: widget.leagueId, idPlayer1: teams[teamIdx].id, idPlayer2: listTeam[0].id, played: false, week: day + 1);
        await database.sendMatch(match);
      }

      for (int idx = 1; idx < halfSize; idx++) {
        int firstTeam = (day + idx) % teamsSize;
        int secondTeam = (day + teamsSize - idx) % teamsSize;
        print(teams[firstTeam].fullName.toString() + "<===>" + teams[secondTeam].fullName.toString());
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

  List<ModelUserLeague> rotate(List<ModelUserLeague> listToRotate) {
    print("rotate \n");
    List<ModelUserLeague> list = listToRotate;

    ModelUserLeague x = list[list.length - 1];
    for (int i = list.length - 1; i > 0; i--) list[i] = list[i - 1];
    list[0] = x;

    for (var user in listToRotate) {
      if (user != null) {
        print("=>" + user.fullName);
      }
    }
    return list;
  }
}
