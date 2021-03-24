import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';

class Chat extends StatefulWidget {
  final ModelUserLeague modelUserLeague;

  const Chat({Key key, @required this.modelUserLeague}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          basicScreenColor(),
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: [
                  /*          Container(
                    height: 100,
                    width: 100,
                    color: Colors.redAccent,
                  ),*/
                  customHeader(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customHeader() {
    return Container(
      height: 80,
      padding: EdgeInsets.all(16).copyWith(left: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(color: Colors.red),
              Expanded(
                child: Text(
                  widget.modelUserLeague.fullName,
                  style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 12),
                ],
              ),
              SizedBox(width: 4),
            ],
          )
        ],
      ),
    );
  }
}
