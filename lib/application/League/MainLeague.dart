import 'package:flutter/material.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'LeagueTable.dart';

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
