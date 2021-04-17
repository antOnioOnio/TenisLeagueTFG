import 'package:flutter/material.dart';
import 'package:tenisleague100/application/Forum/PostList.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../top_providers.dart';
import 'AddPostHeader.dart';
import 'ForumViewModel.dart';

class Forum extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final forunModel = watch(forumModelProvider);
    return ProviderListener<ForumViewModel>(
      provider: forumModelProvider,
      onChange: (context, model) async {
        if (forunModel.isLoading != null) {
          circularLoadingBar();
        }
      },
      child: MainForum(
        viewModel: forunModel,
      ),
    );
  }
}

class MainForum extends StatefulWidget {
  final ForumViewModel viewModel;

  const MainForum({Key key, this.viewModel}) : super(key: key);
  @override
  _MainForumState createState() => _MainForumState();
}

class _MainForumState extends State<MainForum> {
  @override
  void initState() {
    super.initState();
    initVM();
  }

  void initVM() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.viewModel.initUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          basicScreenColorChatBg(),
          SafeArea(
            child: widget.viewModel.isLoading
                ? circularLoadingBar()
                : Column(
                    children: [
                      AddPostHeader(
                        viewModel: widget.viewModel,
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          child: PostList(
                            modelView: widget.viewModel,
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
