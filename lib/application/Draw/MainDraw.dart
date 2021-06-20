import 'package:flutter/material.dart';
import 'package:tenisleague100/application/Draw/DrawByLevel.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/GlobalValues.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainDraw extends StatefulWidget {
  @override
  _MainDrawState createState() => _MainDrawState();
}

class _MainDrawState extends State<MainDraw> {
  List<ModelUserLeague> _everyUser = [];
  List<ModelLeague> _currentTournaments = [];
  bool _isLoading;
  String _levelPrincipianteId = "";
  String _levelMedioId = "";
  String _levelAvanzadoId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTournamentsAndUsers();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? circularLoadingBar()
        : Scaffold(
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
      child: TabBarView(
        children: [
          DrawByLevel(
            users: userByLevel(_everyUser, GlobalValues.levelPrincipiante),
            tournamentID: this._levelPrincipianteId ,
          ),
          DrawByLevel(
            users: userByLevel(_everyUser, GlobalValues.leveMedio),
            tournamentID: this._levelMedioId,
          ),
          DrawByLevel(
            users: userByLevel(_everyUser, GlobalValues.levelAvanzado),
            tournamentID: this._levelAvanzadoId,
          ),
        ],
      ),
    );
  }

  void getTournamentsAndUsers() async {
    print("geUsers called");
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });
    _currentTournaments = await database.getTournamentCollection();
    for (var league in _currentTournaments) {
      if (league.level == GlobalValues.levelPrincipiante) {
        this._levelPrincipianteId = league.id;
      } else if (league.level == GlobalValues.levelAvanzado) {
        this._levelAvanzadoId = league.id;
      } else if (league.level == GlobalValues.leveMedio) {
        this._levelMedioId = league.id;
      }
    }
    _everyUser = await database.getUserCollection();
    setState(() {
      _isLoading = false;
    });
  }

}
