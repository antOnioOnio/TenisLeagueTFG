import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelPost.dart';

class PostList extends StatefulWidget {
  final ForumViewModel modelView;

  const PostList({Key key, this.modelView}) : super(key: key);
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ModelPost>>(
      stream: widget.modelView.postStream(),
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
              final posts = snapshot.data;
              return posts.isEmpty
                  ? Center(child: Text("No hay posts.."))
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: false,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return post(posts[index]);
                      },
                    );
            }
        }
      },
    );
  }

  Widget post(ModelPost modelPost) {
    switch (modelPost.postType) {
      case ModelPost.typeProPMatch:
        return propMatchWidget(modelPost);
        break;
      case ModelPost.typeEvent:
        break;
      case ModelPost.typePicture:
        break;
    }
  }

  Widget propMatchWidget(ModelPost modelPost) {
    Uint8List bytes = base64Decode(modelPost.imageUser);
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
                modelPost.nameOfUser + " propone partido",
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 16),
              ),
              widget.modelView.user.id == modelPost.idUser
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => displaySafetyQuestion(context, modelPost.id),
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
                modelPost.content,
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
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
