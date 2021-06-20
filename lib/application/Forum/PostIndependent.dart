import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tenisleague100/application/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/EventWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/MatchResultWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/PictureWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/PropMatchWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/commomWidgets.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/GlobalValues.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';

class PostIndependent extends StatefulWidget {
  final ForumViewModel viewModel;
  final ModelPost modelPost;

  const PostIndependent({Key key, @required this.viewModel, @required this.modelPost}) : super(key: key);
  @override
  _PostIndependentState createState() => _PostIndependentState();
}

class _PostIndependentState extends State<PostIndependent> {
  TextEditingController _messageController = new TextEditingController();
  final DateFormat formatter = DateFormat.yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          basicScreenColorChatBg(),
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Column(
                    children: [
                      post(widget.modelPost),
                      Expanded(child: comments()),
                      typingContainer(_messageController, sendComment, context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButton(color: Colors.green[800]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget post(ModelPost modelPost) {
    if (modelPost.postType == ModelPost.typeProPMatch) {
      return Hero(
        tag: modelPost.id,
        child: PropMatchWidget(
          modelView: widget.viewModel,
          modelPost: modelPost,
          comingFromIndependent: true,
        ),
      );
    } else if (modelPost.postType == ModelPost.typePicture) {
      return Hero(
        tag: modelPost.id,
        child: PictureWidget(
          modelView: widget.viewModel,
          modelPost: modelPost,
          comingFromIndependent: true,
        ),
      );
    } else if (modelPost.postType == ModelPost.typeEvent) {
      return Hero(
        tag: modelPost.id,
        child: EventWidget(
          modelView: widget.viewModel,
          modelPost: modelPost,
          comingFromIndependent: true,
        ),
      );
    } else if (modelPost.postType == ModelPost.matchResult) {
      return Hero(
        tag: modelPost.id,
        child: MatchResultWidget(
          modelView: widget.viewModel,
          modelPost: modelPost,
          comingFromIndependent: true,
        ),
      );
    }
  }

  Widget comments() {
    return Container(
      child: StreamBuilder<List<ModelComment>>(
        stream: widget.viewModel.commentStream(widget.modelPost.id),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return circularLoadingBar();
            default:
              if (snapshot.hasError) {
                print("there is an error");
                return circularLoadingBar();
              } else {
                final comments = snapshot.data;
                return comments.isEmpty
                    ? Text("No hay comentarios..")
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: false,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return commentWidget(comments[index], comments.length);
                        },
                      );
              }
          }
        },
      ),
    );
  }

  Widget commentWidget(ModelComment modelComment, int currentSize) {
    Uint8List bytes = base64Decode(modelComment.userImage);
    String date = formatter.format(modelComment.createdAt);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Container(
        decoration: containerChatSelection(),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Color(GlobalValues.mainGreen),
                    radius: 15,
                    child: customAvatar(bytes),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      modelComment.userName,
                      style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      modelComment.comment,
                      style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 10),
                    ),
                  ],
                ),
                widget.viewModel.user.id == modelComment.userId
                    ? Expanded(
                        child: GestureDetector(
                          onTap: () => {
                            displaySafetyQuestionComment(widget.viewModel, context, widget.modelPost.id, modelComment.id, currentSize),
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.delete,
                              color: Color(GlobalValues.mainGreen),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  width: 5,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.w100, fontSize: 12),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void sendComment(String comment) {
    if (comment.isNotEmpty) {
      ModelComment newComment = new ModelComment(
          userImage: widget.viewModel.user.image,
          userName: widget.viewModel.user.fullName,
          id: generateUuid(),
          comment: comment,
          createdAt: DateTime.now(),
          userId: widget.viewModel.user.id);

      widget.viewModel.sendComment(newComment, widget.modelPost.id);
    } else {}
  }
}
