import 'package:flutter/material.dart';
import 'package:tenisleague100/application/Draw/DrawByLevel.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
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
  bool _isLoading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
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

  void getUsers() async {
    print("geUsers called");
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });
    _everyUser = await database.getUserCollection();
    setState(() {
      _isLoading = false;
    });
  }

  Widget pages() {
    return Expanded(
      child: TabBarView(
        children: [
          DrawByLevel(
            users: userByLevel(_everyUser, GlobalValues.levelPrincipiante),
          ),
          DrawByLevel(
            users: userByLevel(_everyUser, GlobalValues.leveMedio),
          ),
          DrawByLevel(
            users: userByLevel(_everyUser, GlobalValues.levelAvanzado),
          ),
        ],
      ),
    );
  }
}
