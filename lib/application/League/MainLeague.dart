import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLeague extends StatefulWidget {
  @override
  _MainLeagueState createState() => _MainLeagueState();
}

class _MainLeagueState extends State<MainLeague> {
  List<ModelUserLeague> _everyUser = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*  getUsers();*/
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<Database>(databaseProvider);
    return StreamBuilder(
      stream: database.usersStream(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return circularLoadingBar();
          default:
            if (snapshot.hasError) {
              return showAlertDialog(
                context: context,
                title: 'Error',
                content: "Intentalo de nuevo más tarde",
                defaultActionText: 'OK',
                requiredCallback: false,
              );
            } else {
              final users = snapshot.data;
              _everyUser = users;
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
        }
      },
    );
  }

  Widget pages() {
    return Expanded(
      child: TabBarView(
        children: [
          LeagueTable(
            users: userByLevel(_everyUser, GlobalValues.levelPrincipiante),
          ),
          LeagueTable(
            users: userByLevel(_everyUser, GlobalValues.leveMedio),
          ),
          LeagueTable(
            users: userByLevel(_everyUser, GlobalValues.levelAvanzado),
          ),
        ],
      ),
    );
  }
}

class LeagueTable extends StatelessWidget {
  final List<ModelUserLeague> users;

  const LeagueTable({Key key, @required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(top: 10),
      child: mainListUsers(),
    );
  }

  Widget mainListUsers() {
    return users.isEmpty
        ? Center(child: Text("No hay partidos en este nivel aún.."))
        : ListView(
            children: [
              DataTable(
                horizontalMargin: 6.0,
                columnSpacing: 6.0,
                columns: buildHeadDataRow(),
                rows: List<DataRow>.generate(
                  users.length,
                  (index) => buildBodyDataRow(users[index], index),
                ),
              )
            ],
          );
  }

  buildHeadDataRow() {
    return <DataColumn>[
      buildHeadCell('Clas'),
      buildHeadCell('Jugador'),
      buildHeadCell('Pts'),
      buildHeadCell('PJ'),
      buildHeadCell('PG'),
      buildHeadCell('PP'),
    ];
  }

  buildHeadCell(String text) {
    return DataColumn(
      label: Text(
        text,
        style: GoogleFonts.raleway(color: Color(GlobalValues.mainGreen), fontWeight: FontWeight.normal, fontSize: 14),
        textAlign: TextAlign.center,
        // ),
      ),
    );
  }

  buildBodyDataRow(ModelUserLeague user, int index) {
    return DataRow(cells: <DataCell>[
      DataCell(Text((index + 1).toString())),
      DataCell(Text(user.fullName)),
      DataCell(Text(user.currentScore.toString())),
      DataCell(Text(user.matchPlayed.toString())),
      DataCell(Text(user.matchWins.toString())),
      DataCell(Text(user.matchLosses.toString())),
    ]);
  }
}
