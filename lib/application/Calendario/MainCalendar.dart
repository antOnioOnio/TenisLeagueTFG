import 'package:flutter/material.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../top_providers.dart';

class MainCalendar extends StatefulWidget {
  @override
  _MainCalendarState createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  List<ModelLeague> _currentLeagues = [];
  List<ModelUserLeague> _users;
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
          CalendarByLevel(leagueId: this._levelPrincipianteId),
          CalendarByLevel(leagueId: this._levelMedioId),
          CalendarByLevel(leagueId: this._levelAvanzadoId),
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
    //String currentUserId = sp.getCurrentUSerId();
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
  const CalendarByLevel({Key key, @required this.leagueId}) : super(key: key);
  @override
  _CalendarByLevelState createState() => _CalendarByLevelState();
}

class _CalendarByLevelState extends State<CalendarByLevel> {
  @override
  void initState() {
    super.initState();
    print("============> " + widget.leagueId);
  }

  @override
  Widget build(BuildContext context) {
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
                        ? Center(child: Text("No hay partidos.."))
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
        : Center(child: Text("No hay partidos.."));
  }

  Widget match(ModelMatch match) {
    return Text(match.id);
  }
}
