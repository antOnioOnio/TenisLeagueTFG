import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/PostIndependent.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelPost.dart';

import '../ForumViewModel.dart';

class PropMatch extends StatefulWidget {
  final ForumViewModel modelView;
  final ModelPost modelPost;
  final bool showComments;

  const PropMatch({Key key, @required this.modelView, @required this.modelPost, this.showComments}) : super(key: key);
  @override
  _PropMatchState createState() => _PropMatchState();
}

class _PropMatchState extends State<PropMatch> {
  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(widget.modelPost.imageUser);
    return Container(
      decoration: containerChatSelection(),
      margin: EdgeInsets.only(bottom: 10),
      height: 100,
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
                widget.modelPost.nameOfUser + " propone partido",
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 16),
              ),
              widget.modelView.user.id == widget.modelPost.idUser
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => displaySafetyQuestion(context, widget.modelPost.id),
                          child: Icon(
                            Icons.delete,
                            color: Color(GlobalValues.mainGreen),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                width: 10,
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
          Expanded(
            child: Container(
              decoration: decorationTopBorder(),
              child: widget.showComments
                  ? listComments()
                  : Center(
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => PostIndependent(viewModel: widget.modelView, modelPost: widget.modelPost)),
                          )
                        },
                        child: Icon(
                          Icons.comment,
                          color: Color(GlobalValues.mainGreen),
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget listComments() {
    return widget.modelPost.comments == null || widget.modelPost.comments.isEmpty
        ? Center(
            child: Text(
            "No hay comentarios aún",
            style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
          ))
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: false,
            itemCount: widget.modelPost.comments.length,
            itemBuilder: (context, index) {
              return comment(widget.modelPost.comments[index]);
            },
          );
  }

  Widget comment(ModelComment comment) {
    return Row(
      children: [
        Text(
          comment.comment,
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
        )
      ],
    );
  }

  Future<void> displaySafetyQuestion(BuildContext context, String idPost) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirma por favor"),
        content: Text("¿Quieres eliminar este post?"),
        actions: [
          TextButton(
            child: Text(
              "Si",
            ),
            onPressed: () => {widget.modelView.deletePost(idPost), Navigator.pop(context)},
          ),
          TextButton(
            child: Text(
              "No",
            ),
            onPressed: () => {
              Navigator.pop(context),
            },
          )
        ],
      ),
    );
  }
}
