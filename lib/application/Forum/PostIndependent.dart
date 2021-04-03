import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/PictureWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/PropMatchWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/commomWidgets.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
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
                child: Column(
                  children: [
                    post(widget.modelPost),
                    typingContainer(_messageController/*, sendComment*/),
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
        ],
      ),
    );
  }

/*  void sendComment(String comment) {
   print("comment ==> " + comment);
    if (comment.isNotEmpty) {
      ModelComment newComment = new ModelComment(
          userImage: widget.viewModel.user.image, id: generateUuid(), comment: comment, createdAt: DateTime.now(), userId: widget.viewModel.user.id);

      List<ModelComment> list = [];
      list.add(newComment);
      ModelPost post = widget.modelPost.copyWith(list);

      widget.viewModel.sendPost(post);
    } else {}
  }*/

  Widget post(ModelPost modelPost) {
    if (modelPost.postType == ModelPost.typeProPMatch) {
      return Hero(
        tag: modelPost.id,
        child: PropMatchWidget(
          modelView: widget.viewModel,
          modelPost: modelPost,
          showComments: true,
        ),
      );
    } else if (modelPost.postType == ModelPost.typePicture) {
      return Hero(
        tag: modelPost.id,
        child: PictureWidget(
          modelView: widget.viewModel,
          modelPost: modelPost,
          showComments: true,
        ),
      );
    }
  }
}
