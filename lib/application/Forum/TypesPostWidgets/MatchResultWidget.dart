import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/commomWidgets.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelPost.dart';

import '../ForumViewModel.dart';

class MatchResultWidget extends StatefulWidget {
  final ForumViewModel modelView;
  final ModelPost modelPost;
  final bool comingFromIndependent;

  const MatchResultWidget({Key key, @required this.modelView, @required this.modelPost, this.comingFromIndependent}) : super(key: key);
  @override
  _MatchResultWidgetState createState() => _MatchResultWidgetState();
}

class _MatchResultWidgetState extends State<MatchResultWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(bottom: 10),
      height: 115,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Partido terminado",
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.modelPost.content,
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 0.5,
            color: Color(GlobalValues.mainGreen),
          ),
          SizedBox(
            height: 10,
          ),
          rowCommentsAndDelete(widget.modelView, context, widget.modelPost, widget.comingFromIndependent),
        ],
      ),
    );
  }
}
