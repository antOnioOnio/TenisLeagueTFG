import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/Database/Database.dart';

import '../top_providers.dart';

class MainUsers extends StatefulWidget {
  @override
  _MainUsersState createState() => _MainUsersState();
}

class _MainUsersState extends State<MainUsers> {
  bool _isLoading;
  List<ModelUserLeague> _everyUser = [];
  @override
  void initState() {
    super.initState();
    getUsers();
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
                UserList(
                  users: userByLevel(_everyUser, GlobalValues.levelPrincipiante),
                ),
                UserList(
                  users: userByLevel(_everyUser, GlobalValues.leveMedio),
                ),
                UserList(
                  users: userByLevel(_everyUser, GlobalValues.levelAvanzado),
                ),
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
}

class UserList extends StatelessWidget {
  final List<ModelUserLeague> users;
  const UserList({Key key, @required this.users}) : super(key: key);

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
        ? Center(child: Text("No hay usuarios en este nivel aún.."))
        : ListView(
            children: [
              DataTable(
                columns: buildHeadDataRow(),
                rows: List<DataRow>.generate(
                  users.length,
                  (index) => buildBodyDataRow(users[index]),
                ),
              )
            ],
          );
  }

  buildHeadDataRow() {
    return <DataColumn>[
      buildHeadCell('Nombre'),
      buildHeadCell('Email'),
      buildHeadCell('Teléfono'),
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

  buildBodyDataRow(ModelUserLeague user) {
    return DataRow(cells: <DataCell>[
      DataCell(Text(user.fullName)),
      DataCell(Text(user.email)),
      DataCell(Text(user.tlf ?? "")),
    ]);
  }
}
