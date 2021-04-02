import 'package:flutter/material.dart';
import 'package:tenisleague100/application/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/PropMatchWidget.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/models/ModelPost.dart';

class PostIndependent extends StatefulWidget {
  final ForumViewModel viewModel;
  final ModelPost modelPost;

  const PostIndependent({Key key, @required this.viewModel, @required this.modelPost}) : super(key: key);
  @override
  _PostIndependentState createState() => _PostIndependentState();
}

class _PostIndependentState extends State<PostIndependent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          basicScreenColorChatBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Hero(
                    tag: widget.modelPost.id,
                    child: PropMatch(modelView: widget.viewModel, modelPost: widget.modelPost, showComments: true,),
                  ),
                ],
              ),
            ),
          ),
          Positioned(bottom: 10, child: BackButton(color: Colors.green[800])),
        ],
      ),
    );
  }
}
