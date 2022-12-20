// ignore_for_file: depend_on_referenced_packages

import 'package:courseproject_ui_dd2022/data/service/data_service.dart';
import 'package:courseproject_ui_dd2022/data/service/sync_service.dart';
import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:courseproject_ui_dd2022/ui/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/service/auth_service.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user.dart';
import '../../internal/app_config.dart';
import '../navigator.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  AppViewModel({required this.context}) {
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

  final _authService = AuthService();
  final _dataService = DataService();
  final _scrollListController = ScrollController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  Map<String, String>? headers;

  User? _user;
  User? get user => _user;
  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  Image? userAvatar;
  Image? get avatar => userAvatar;
  set avatar(Image? val) {
    userAvatar = val;
    notifyListeners();
  }

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

  void setAvatar(Image newAvatar) {
    avatar = newAvatar;
  }

  void _logout() {
    _authService.logout().then((value) => AppNavigator.toLoader());
  }

  void _scrollUp() {
    _scrollListController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInCubic);
  }

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();

    await SyncService().syncPosts();
    posts = await _dataService.getPosts();
  }

  void toUserProfile(BuildContext bc, User profileUser) {
    Navigator.of(bc).push(MaterialPageRoute(
        builder: (__) => ProfileWidget.create(bc, profileUser)));
  }
}

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({Key? key}) : super(key: key);

  ImageProvider<Object>? getAvatar(User? user) {
    if (user == null) return null;
    if (user.linkToAvatar?.isNotEmpty ?? false) {
      return NetworkImage("$baseUrl${user.linkToAvatar}");
    } else {
      return const AssetImage("images/no_avatar.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();
    var size = MediaQuery.of(context).size;
    var controller = viewModel._scrollListController;
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            GestureDetector(
                onTap: () => viewModel.toUserProfile(context, viewModel.user!),
                child:
                    CircleAvatar(backgroundImage: viewModel.userAvatar?.image)),
            Text(viewModel.user == null ? " Guest" : " ${viewModel.user!.name}")
          ]),
          actions: [
            IconButton(
                onPressed: viewModel._logout, icon: const Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => AppNavigator.toPostCreation(),
            child: const Icon(Icons.add)),
        body: viewModel.posts == null
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
                                color: Colors.grey,
                                height: size.width,
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          color: Colors.grey.shade600,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () =>
                                                      viewModel.toUserProfile(
                                                          context,
                                                          thisPost.author),
                                                  child: CircleAvatar(
                                                    backgroundImage: getAvatar(
                                                        thisPost.author),
                                                  )),
                                              const SizedBox(width: 16),
                                              Text(thisPost.author.name),
                                            ],
                                          )),
                                      const SizedBox(height: 4),
                                      Text(thisPost.postContent ?? ""),
                                      const SizedBox(height: 4),
                                      Expanded(
                                          child: PageView.builder(
                                              onPageChanged: (value) =>
                                                  viewModel.onPageChanged(
                                                      index, value),
                                              itemCount: thisPost
                                                  .postAttachments.length,
                                              itemBuilder:
                                                  (pageContext, pageIndex) {
                                                return Container(
                                                    color: Colors.grey.shade500,
                                                    child: Image(
                                                        image: NetworkImage(
                                                            "$baseUrl${thisPost.postAttachments[pageIndex].url}",
                                                            headers: viewModel
                                                                .headers)));
                                              })),
                                      PageIndicator(
                                        count: thisPost.postAttachments.length,
                                        current: viewModel.pager[index],
                                      ),
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

  static Widget create() => ChangeNotifierProvider<AppViewModel>(
      create: (context) => AppViewModel(context: context),
      child: const MainAppWidget());
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
