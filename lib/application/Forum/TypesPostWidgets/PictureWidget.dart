import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/PostIndependent.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/commomWidgets.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/services/GlobalValues.dart';

import '../ForumViewModel.dart';

class PictureWidget extends StatefulWidget {
  final ForumViewModel modelView;
  final ModelPost modelPost;
  final bool comingFromIndependent;

  const PictureWidget({Key key, @required this.modelView, @required this.modelPost, this.comingFromIndependent}) : super(key: key);
  @override
  _PictureWidgetState createState() => _PictureWidgetState();
}

class _PictureWidgetState extends State<PictureWidget> {

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(widget.modelPost.imageUser);
    Uint8List bytesImage = base64Decode(widget.modelPost.image);
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(bottom: 10),
      height: 420,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              CircleAvatar(
                backgroundColor: Color(GlobalValues.mainGreen),
                radius: 15,
                child: customAvatar(bytes),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.modelPost.nameOfUser,
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Center(
            child: Container(
              height: 320.0,
              width: 350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: new Image.memory(
                  bytesImage,
                  fit: BoxFit.fill,
                  height: 37.0,
                  width: 37.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
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
            height: 5,
          ),
          rowCommentsAndDelete(widget.modelView, context, widget.modelPost, widget.comingFromIndependent),
        ],
      ),
    );
  }
}
