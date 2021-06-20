import 'package:flutter/material.dart';
import 'package:tenisleague100/application/Calendario/CalendarLevel.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/GlobalValues.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
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
  ModelUserLeague _currentUser;
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
          CalendarByLevel(
            leagueId: this._levelPrincipianteId,
            users: userByLevel(_users, _currentUser.level),
            justMyMatches: true,
          ),
          CalendarByLevel(
            leagueId: this._levelPrincipianteId,
            users: userByLevel(_users, GlobalValues.levelPrincipiante),
            justMyMatches: false,
          ),
          CalendarByLevel(
            leagueId: this._levelMedioId,
            users: userByLevel(_users, GlobalValues.leveMedio),
            justMyMatches: false,
          ),
          CalendarByLevel(
            leagueId: this._levelAvanzadoId,
            users: userByLevel(_users, GlobalValues.levelAvanzado),
            justMyMatches: false,
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
    _currentUser = await database.getCurrentUser();
    setState(() {
      _isLoading = false;
    });
  }
}
