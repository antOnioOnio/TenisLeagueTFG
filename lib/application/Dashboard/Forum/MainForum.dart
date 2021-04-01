import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Dashboard/Forum/AddPost.dart';
import 'package:tenisleague100/application/Dashboard/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../top_providers.dart';

final forumModelProvider = ChangeNotifierProvider<ForumViewModel>((ref) {
  final database = ref.watch(databaseProvider);
  return ForumViewModel(database: database);
});

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
    await widget.viewModel.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          basicScreenColorChatBg(),
          SafeArea(
            child: widget.viewModel.isLoading
                ? circularLoadingBar()
                : AddPost(viewModel: widget.viewModel,),
          ),
        ],
      ),
    );
  }
}
