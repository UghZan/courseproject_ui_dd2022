import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/service/auth_service.dart';
import '../../domain/models/user.dart';
import '../../internal/token_storage.dart';
import '../navigator.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  _ViewModel({required this.context}) {
    asyncInit();
  }
  final AuthService _authService = AuthService();
  Map<String, String>? headers;

  User? _user;
  User? get user => _user;
  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  void _logout() {
    _authService.logout().then((value) => AppNavigator.toLoader());
  }

  void _refresh() async {
    await _authService.tryGetUser();
  }

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }
}

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.user == null
            ? "Hello Guest"
            : "Hello, ${viewModel.user!.name}"),
        actions: [
          IconButton(
              onPressed: viewModel._logout, icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: viewModel._refresh, icon: const Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          if (viewModel.user != null) AppNavigator.toProfile(viewModel.user!)
        },
        child: const Icon(Icons.person),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const MainAppWidget());
}
