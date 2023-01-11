import 'package:courseproject_ui_dd2022/internal/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/user.dart';
import '../../../internal/dependencies/repository_module.dart';
import '../../navigation/tab_navigator.dart';

class _ViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();

  bool isLoaded = true;
  BuildContext context;
  _ViewModel({required this.context}) {
    asyncInit();
    searchTEC.addListener(() async {
      if (searchTEC.text.isEmpty) {
        _users?.clear();
        notifyListeners();
        return;
      }
      isLoaded = false;
      users = await _api.searchUsers(searchTEC.text).then((value) {
        isLoaded = true;
        return value;
      });
    });
  }

  List<User>? _users;
  List<User>? get users => _users;
  set users(List<User>? u) {
    _users = u;
    notifyListeners();
  }

  TextEditingController searchTEC = TextEditingController();

  void asyncInit() async {}

  @override
  void dispose() {
    searchTEC.dispose();
    super.dispose();
  }

  void toUserProfile(User profileUser) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.userProfile, arguments: profileUser);
  }
}

class UserListWidget extends StatelessWidget {
  const UserListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextField(
              controller: viewModel.searchTEC,
              expands: false,
              decoration:
                  const InputDecoration(hintText: "Start writing username..."),
            ),
            viewModel.isLoaded
                ? Expanded(
                    child: ListView.builder(
                    itemBuilder: ((context, index) {
                      var thisUser = viewModel._users?[index];
                      if (thisUser != null) {
                        return ListTile(
                          leading: GestureDetector(
                              onTap: () => viewModel.toUserProfile(thisUser),
                              child: CircleAvatar(
                                  backgroundImage: Utils.getAvatar(thisUser))),
                          title: Text(thisUser.name),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    itemCount: viewModel._users?.length ?? 0,
                  ))
                : const CircularProgressIndicator()
          ],
        ));
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const UserListWidget());
}
