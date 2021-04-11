import 'package:flutter/material.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/Database/Database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLeague extends StatefulWidget {
  @override
  _MainLeagueState createState() => _MainLeagueState();
}

class _MainLeagueState extends State<MainLeague> {
  bool _isLoading;
  List<ModelUserLeague> _everyUser = [];
  List<ModelLeague> _leagues = [];
  @override
  void initState() {
    super.initState();
    getUsersAndLeagues();
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
              child: DefaultTabController(
                length: 3,
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
      child: _isLoading
          ? circularLoadingBar()
          : TabBarView(
              children: [
                LeagueTable(
                  users: userByLevel(_everyUser, GlobalValues.levelPrincipiante),
                  leagueId: leagueId(_leagues, GlobalValues.levelPrincipiante),
                ),
                LeagueTable(
                  users: userByLevel(_everyUser, GlobalValues.leveMedio),
                  leagueId: leagueId(_leagues, GlobalValues.leveMedio),
                ),
                LeagueTable(
                  users: userByLevel(_everyUser, GlobalValues.levelAvanzado),
                  leagueId: leagueId(_leagues, GlobalValues.levelAvanzado),
                ),
              ],
            ),
    );
  }

  void getUsersAndLeagues() async {
    print("geUsers called");
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });
    _everyUser = await database.getUserCollection();
    _leagues = await database.getLeaguesCollection();
    setState(() {
      _isLoading = false;
    });
  }
}

class LeagueTable extends StatefulWidget {
  final List<ModelUserLeague> users;
  final String leagueId;

  const LeagueTable({Key key, @required this.users,@required this.leagueId}) : super(key: key);

  @override
  _LeagueTableState createState() => _LeagueTableState();
}

class _LeagueTableState extends State<LeagueTable> {
  List<ModelMatch> _matches = [];
  bool emptyLeague;
  @override
  void initState() {
    super.initState();
    if(widget.leagueId != ""){
      getLeagues();
      emptyLeague = false;
    }else{
      emptyLeague = true;
    }

  }

  void getLeagues() async {
    print("getLeagues called");
    final database = context.read<Database>(databaseProvider);
    leagues = await database.getLeaguesCollection();
    for ( var obj in leagues){
      print("obj==> " + obj.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(top: 10),
      child: Text("shioas"),
    );
  }
}
