import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';

class DrawByLevel extends StatefulWidget {
  final List<ModelUserLeague> users;
  const DrawByLevel({Key key, @required this.users}) : super(key: key);

  @override
  _DrawByLevelState createState() => _DrawByLevelState();
}

class _DrawByLevelState extends State<DrawByLevel> {
  List<Widget> widgets = [];
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    initWidgets();
  }

  void initWidgets() {
    setState(() {
      _isLoading = true;
    });
    for (var i = 0; i < widget.users.length; i++) {
      widgets.add(new Text(widget.users[i].fullName));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(top: 10),
      child: _isLoading ? circularLoadingBar() : mainListUsers(),
    );
  }

  Widget mainListUsers() {
    return Container(
      child: Column(
        children: widgets,
      ),
    );
  }

  Widget customWidget(String user1, String user2) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 40,
          color: Colors.blueAccent,
          child: Text(user1),
        ),
        Container(
          width: 100,
          height: 40,
          color: Colors.red,
          child: Text(user2),
        ),
      ],
    );
  }
}
