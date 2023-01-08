// ignore_for_file: depend_on_referenced_packages

import 'package:courseproject_ui_dd2022/data/service/data_service.dart';
import 'package:courseproject_ui_dd2022/data/service/sync_service.dart';
import 'package:courseproject_ui_dd2022/ui/widgets/common/react_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/post_model.dart';
import '../../../domain/models/user.dart';
import '../../../internal/app_config.dart';
import '../../../internal/utils.dart';
import '../../navigation/tab_navigator.dart';

class HomeViewModel extends ChangeNotifier {
  BuildContext context;
  HomeViewModel({required this.context}) {
    asyncInit();
    _scrollListController.addListener(() {
      var max = _scrollListController.position.maxScrollExtent;
      var current = _scrollListController.offset;
      var percent = (current / max * 100);
      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            posts = <PostModel>[...posts!, ...posts!];
            isLoading = false;
          });
        }
      }
    });
  }

  final _dataService = DataService();
  final _scrollListController = ScrollController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  Map<String, String>? headers;

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void asyncInit() async {
    refresh();
  }

  void refresh() async {
    isLoading = true;
    await SyncService().syncPosts().then((value) => isLoading = false);
    posts = await _dataService.getPosts();
  }

  void toUserProfile(User profileUser) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.userProfile, arguments: profileUser)
        .then((value) => refresh());
  }

  void toPostDetails(PostModel post) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: post)
        .then((value) => refresh());
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeViewModel>();
    var size = MediaQuery.of(context).size;
    var controller = viewModel._scrollListController;

    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: viewModel.refresh,
              icon: const Icon(Icons.refresh_outlined))
        ]),
        body: viewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        controller: controller,
                        itemBuilder: (context, index) {
                          Widget result;
                          var posts = viewModel.posts;
                          if (posts != null) {
                            var thisPost = posts[index];
                            result = Container(
                                constraints: BoxConstraints.loose(
                                    Size(size.width, size.width)),
                                color: Colors.grey,
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          color: Colors.grey[600],
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () =>
                                                      viewModel.toUserProfile(
                                                          thisPost.author),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        Utils.getAvatar(
                                                            thisPost.author),
                                                  )),
                                              const SizedBox(width: 16),
                                              Text(thisPost.author.name),
                                            ],
                                          )),
                                      const SizedBox(height: 4),
                                      Text(thisPost.postContent ?? ""),
                                      const SizedBox(height: 4),
                                      thisPost.postAttachments.isNotEmpty
                                          ? Expanded(
                                              child: PageView.builder(
                                                  onPageChanged: (value) =>
                                                      viewModel.onPageChanged(
                                                          index, value),
                                                  itemCount: thisPost
                                                      .postAttachments.length,
                                                  itemBuilder:
                                                      (pageContext, pageIndex) {
                                                    return Container(
                                                        color: Colors.grey[500],
                                                        child: Image(
                                                            image: NetworkImage(
                                                                "$baseUrl${thisPost.postAttachments[pageIndex].url}",
                                                                headers: viewModel
                                                                    .headers)));
                                                  }))
                                          : const SizedBox.shrink(),
                                      thisPost.postAttachments.isNotEmpty
                                          ? PageIndicator(
                                              count: thisPost
                                                  .postAttachments.length,
                                              current: viewModel.pager[index],
                                            )
                                          : const SizedBox.shrink(),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ReactButtonWidget.create(
                                                context, thisPost),
                                            Row(children: [
                                              Text(thisPost.commentsCount
                                                  .toString()),
                                              IconButton(
                                                icon: const Icon(Icons.comment),
                                                onPressed: () => viewModel
                                                    .toPostDetails(thisPost),
                                              ),
                                            ]),
                                          ])
                                    ]));
                          } else {
                            result = const SizedBox.shrink();
                          }

                          return result;
                        },
                        separatorBuilder: ((context, index) => const Divider()),
                        itemCount: viewModel.posts?.length ?? 0),
                  ),
                  if (viewModel.isLoading) const LinearProgressIndicator()
                ],
              ));
  }

  static Widget create() => ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(context: context),
      child: const HomeWidget());
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator(
      {Key? key, required this.count, required this.current, this.width = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < count; i++) {
      widgets.add(
        Icon(
          Icons.circle,
          size: i == (current ?? 0) ? width * 1.4 : width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...widgets],
    );
  }
}
