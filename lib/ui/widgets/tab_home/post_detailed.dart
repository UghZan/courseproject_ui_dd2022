// ignore_for_file: depend_on_referenced_packages
import 'package:courseproject_ui_dd2022/domain/models/comment_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_comment_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/post_model.dart';
import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:courseproject_ui_dd2022/ui/widgets/common/react_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/service/data_service.dart';
import '../../../data/service/database.dart';
import '../../../data/service/sync_service.dart';
import '../../../domain/models/comment.dart';
import '../../../domain/models/user.dart';
import '../../../internal/app_config.dart';
import '../../../internal/dependencies/repository_module.dart';
import '../../../internal/utils.dart';
import '../../navigation/tab_navigator.dart';
import 'home.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final PostModel? post;
  final _api = RepositoryModule.apiRepository();
  _ViewModel({required this.context, required this.post}) {
    commentController.addListener(() {
      comment = commentController.text;
    });
    asyncInit();
  }

  int _pageIndex = 0;
  set pageIndex(int newIndex) {
    _pageIndex = newIndex;
    notifyListeners();
  }

  int get pageIndex => _pageIndex;

  Map<String, String>? headers;
  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void toUserProfile(User profileUser) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.userProfile, arguments: profileUser);
  }

  String? comment;
  TextEditingController commentController = TextEditingController();

  User? cachedUser;

  List<CommentModel>? _comments;
  List<CommentModel>? get comments => _comments;
  set comments(List<CommentModel>? val) {
    _comments = val;
    notifyListeners();
  }

  void createComment() async {
    var newComment = CreateCommentModel(postContent: comment!);
    commentController.text = "";
    FocusScope.of(context).unfocus();
    await _api.createComment(post!.id, newComment).then((value) async {
      post!.commentsCount++;
      asyncInit();
    });
  }

  Future removeComment(String commentId) async {
    await _api.removeComment(commentId).then((value) async {
      post!.commentsCount--;
      DB.instance.delete<Comment>(Comment.fromJson(
          comments!.firstWhere((element) => element.id == commentId).toJson()));
      asyncInit();
    });
  }

  void asyncInit() async {
    await SyncService().syncCommentsOnPost(post!.id).then((value) async =>
        comments = await DataService().getCommentsForPost(post!.id));
    cachedUser ??= await SharedPrefs.getStoredUser();
  }
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
                            ReactButtonWidget.create(context, post),
                            Row(children: [
                              Text(post.commentsCount.toString()),
                              IconButton(
                                icon: const Icon(Icons.comment),
                                onPressed: () {},
                              ),
                            ]),
                          ]),
                      Container(
                          color: Colors.grey[400],
                          child: Row(children: [
                            Expanded(
                                child: TextField(
                              controller: viewModel.commentController,
                              expands: false,
                              decoration: const InputDecoration(
                                  hintText: "New comment..."),
                            )),
                            IconButton(
                                onPressed: () => viewModel.createComment(),
                                icon: const Icon(Icons.send))
                          ])),
                      Container(
                        color: Colors.grey[400],
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              var thisComment = viewModel.comments?[index];
                              if (thisComment != null) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () => viewModel.toUserProfile(
                                              thisComment.author),
                                          child: Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  color: Colors.grey[200],
                                                  child: Column(children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          Utils.getAvatar(
                                                              thisComment
                                                                  .author),
                                                    ),
                                                    Text(
                                                        thisComment.author.name)
                                                  ])))),
                                      const SizedBox(width: 16),
                                      Text(thisComment.postContent!),
                                      viewModel.cachedUser?.id ==
                                              thisComment.author.id
                                          ? IconButton(
                                              onPressed: () =>
                                                  viewModel.removeComment(
                                                      thisComment.id),
                                              icon: const Icon(
                                                  Icons.delete_outline))
                                          : const SizedBox.shrink()
                                    ]);
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                            separatorBuilder: ((context, index) =>
                                const Divider()),
                            itemCount: viewModel.comments?.length ?? 0),
                      )
                    ])));
  }

  static create(Object? arg) {
    PostModel? post = arg as PostModel;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          _ViewModel(context: context, post: post),
      child: const PostDetailed(),
    );
  }
}
