// ignore_for_file: depend_on_referenced_packages
import 'package:courseproject_ui_dd2022/domain/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/user.dart';
import '../../../internal/app_config.dart';
import '../../../internal/utils.dart';
import '../../navigation/tab_navigator.dart';
import 'home.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final PostModel? post;
  _ViewModel({required this.context, required this.post});

  void toUserProfile(User profileUser) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.userProfile, arguments: profileUser);
  }

  int _pageIndex = 0;
  set pageIndex(int newIndex) {
    _pageIndex = newIndex;
    notifyListeners();
  }

  int get pageIndex => _pageIndex;

  Map<String, String>? headers;
}

class PostDetailed extends StatelessWidget {
  const PostDetailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var post = viewModel.post;
    return post == null
        ? const SafeArea(child: Text("Failed to load post"))
        : SafeArea(
            child: Container(
                color: Colors.grey,
                padding: const EdgeInsets.all(2),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          color: Colors.grey[600],
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () =>
                                      viewModel.toUserProfile(post.author),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        Utils.getAvatar(post.author),
                                  )),
                              const SizedBox(width: 16),
                              Text(post.author.name),
                            ],
                          )),
                      const SizedBox(height: 4),
                      Text(post.postContent ?? ""),
                      const SizedBox(height: 4),
                      post.postAttachments.isNotEmpty
                          ? Expanded(
                              child: PageView.builder(
                                  onPageChanged: (value) =>
                                      viewModel.pageIndex = value,
                                  itemCount: post.postAttachments.length,
                                  itemBuilder: (pageContext, pageIndex) {
                                    return Container(
                                        color: Colors.grey[500],
                                        child: Image(
                                            image: NetworkImage(
                                                "$baseUrl${post.postAttachments[pageIndex].url}",
                                                headers: viewModel.headers)));
                                  }))
                          : const SizedBox.shrink(),
                      post.postAttachments.isNotEmpty
                          ? PageIndicator(
                              count: post.postAttachments.length,
                              current: viewModel.pageIndex,
                            )
                          : const SizedBox.shrink(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              IconButton(
                                icon: const Icon(Icons.favorite),
                                onPressed: () {},
                              ),
                              Text(post.reactionsCount.toString())
                            ]),
                            Row(children: [
                              Text(post.commentsCount.toString()),
                              IconButton(
                                icon: const Icon(Icons.comment),
                                onPressed: () {},
                              ),
                            ]),
                          ]),
                      Expanded(
                          child: Container(
                        color: Colors.grey[350],
                        child: Column(children: [const Text("Comments")]),
                      ))
                    ])));
  }

  static create(Object? arg) {
    PostModel? post;
    if (arg != null && arg is PostModel) post = arg;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          _ViewModel(context: context, post: post),
      child: const PostDetailed(),
    );
  }
}
