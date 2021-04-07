import 'package:flutter/material.dart';
import 'package:tenisleague100/application/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/EventWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/PictureWidget.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/PropMatchWidget.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
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
              print("there is an error");
              return circularLoadingBar();
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
    if (modelPost.postType == ModelPost.typeProPMatch) {
      return Hero(
        tag: modelPost.id,
        child: PropMatchWidget(
          modelView: widget.modelView,
          modelPost: modelPost,
          comingFromIndependent: false,
        ),
      );
    } else if (modelPost.postType == ModelPost.typePicture) {
      return Hero(
        tag: modelPost.id,
        child: PictureWidget(
          modelView: widget.modelView,
          modelPost: modelPost,
          comingFromIndependent: false,
        ),
      );
    } else if (modelPost.postType == ModelPost.typeEvent) {
      return Hero(
        tag: modelPost.id,
        child: EventWidget(
          modelView: widget.modelView,
          modelPost: modelPost,
          comingFromIndependent: false,
        ),
      );
    }
  }
}
