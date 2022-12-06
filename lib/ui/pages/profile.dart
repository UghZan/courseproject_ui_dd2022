import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/user.dart';
import '../../internal/app_config.dart';
import '../../internal/token_storage.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  _ViewModel({required this.context}) {
    asyncInit();
  }
  Map<String, String>? headers;

  User? _user;
  User? get user => _user;
  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }
}

class ProfileWidget extends StatelessWidget {
  final User profileTarget;
  const ProfileWidget({Key? key, required this.profileTarget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(profileTarget.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            constraints: BoxConstraints(
                minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 300),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("$baseUrl${profileTarget.linkToAvatar}",
                      headers: viewModel.headers),
                  fit: BoxFit.fitWidth),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  profileTarget.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      shadows: [
                        Shadow(blurRadius: 0.5, offset: Offset(-1, -1)),
                        Shadow(blurRadius: 0.5, offset: Offset(1, 1))
                      ]),
                  textAlign: TextAlign.left,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.email),
              const SizedBox(
                width: 8,
              ),
              Text(profileTarget.email,
                  style: const TextStyle(
                      fontSize: 24, fontStyle: FontStyle.italic)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.person),
              const SizedBox(
                width: 8,
              ),
              Text(
                  "User for ${DateTime.now().difference(profileTarget.createDate).inDays} days",
                  style: const TextStyle(
                      fontSize: 24, fontStyle: FontStyle.italic)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget create(User user) => ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: ProfileWidget(profileTarget: user));
}

/* */
