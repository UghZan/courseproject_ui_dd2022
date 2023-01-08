// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:courseproject_ui_dd2022/data/service/auth_service.dart';
import 'package:courseproject_ui_dd2022/data/service/data_service.dart';
import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/user.dart';
import '../../../internal/app_config.dart';
import '../../../internal/dependencies/repository_module.dart';
import '../../navigation/app_navigator.dart';
import '../common/camera_widget.dart';
import '../app.dart';

class _ViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();
  final _authService = AuthService();
  BuildContext context;

  late AppViewModel appViewModel;
  _ViewModel({required this.context, User? profileUser}) {
    this.profileUser = profileUser;
    asyncInit();
    appViewModel = context.read<AppViewModel>();
  }
  Map<String, String>? headers;

  User? _visitorUser;
  User? get visitorUser => _visitorUser;
  set visitorUser(User? user) {
    _visitorUser = user;
    notifyListeners();
  }

  User? _profileUser;
  User? get profileUser => _profileUser;
  set profileUser(User? user) {
    _profileUser = user;
    notifyListeners();
  }

  bool isSelfProfile = false;

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  Future tryChangePhoto(bool camera) async {
    if (!isSelfProfile) return;

    String? imagePath;
    File? imageFile;

    if (camera) {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (newContext) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: SafeArea(
            child: CameraWidget(
              onFile: (file) {
                imagePath = file.path;
                Navigator.of(newContext).pop();
              },
            ),
          ),
        ),
      ));
      if (imagePath != null) {
        imageFile = File(imagePath!);
      }
    } else {
      XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 2560.0, maxHeight: 2560.0);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    }

    if (imageFile != null) {
      avatar = null;
      var t = await _api.uploadFiles(files: [imageFile]);
      if (t.isNotEmpty) {
        await _api.addAvatarForUser(t.first);
        //re-obtain user with correct avatar
        visitorUser = await _api.getCurrentUser();
        //ensure that all logic still works and considers this *our* profile
        profileUser = visitorUser;
        _dataService.createOrUpdateUser(profileUser!);

        var img = await NetworkAssetBundle(
                Uri.parse("$baseUrl${visitorUser!.linkToAvatar}"))
            .load("$baseUrl${visitorUser!.linkToAvatar}?v=1");
        appViewModel.avatar = Image.memory(img.buffer.asUint8List());
        avatar = Image.memory(img.buffer.asUint8List());
      }
    }
  }

  Future<Image> getAvatar() async {
    if (profileUser?.linkToAvatar != null) {
      var img = await NetworkAssetBundle(
              Uri.parse("$baseUrl${profileUser?.linkToAvatar!}"))
          .load("$baseUrl${profileUser?.linkToAvatar!}?v=1");
      return Image.memory(
        img.buffer.asUint8List(),
        fit: BoxFit.fill,
      );
    } else {
      return Image.asset("images/no_avatar.png");
    }
  }

  void asyncInit() async {
    visitorUser = await SharedPrefs.getStoredUser();
    profileUser ??= visitorUser;
    if (visitorUser!.id == profileUser!.id) {
      isSelfProfile = true;
    }

    avatar = await getAvatar();
  }

  Future logout() async {
    await _authService.logout();
    AppNavigator.toLoader();
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: GestureDetector(
                              onTap: () =>
                                  _cameraGalleryPicker(context, viewModel),
                              child: SizedBox(
                                  height: size.width,
                                  child: viewModel.avatar))),
                      Text(
                        viewModel.profileUser?.name ?? "",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 36),
                        textAlign: TextAlign.left,
                      )
                    ]),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.email),
              const SizedBox(
                width: 8,
              ),
              Text(viewModel.profileUser?.email ?? "",
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
                  viewModel.profileUser == null
                      ? ""
                      : "User for ${DateTime.now().difference(DateTime.tryParse(viewModel.profileUser!.createDate)!).inDays} days",
                  style: const TextStyle(
                      fontSize: 24, fontStyle: FontStyle.italic)),
            ],
          ),
          if (viewModel.isSelfProfile)
            TextButton(onPressed: viewModel.logout, child: const Text("Logout"))
        ],
      ),
    );
  }

  void _cameraGalleryPicker(BuildContext context, _ViewModel viewModel) {
    showModalBottomSheet<void>(
        // context and builder are
        // required properties in this widget
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => viewModel.tryChangePhoto(true),
                      child: const Text("Take a picture")),
                  TextButton(
                      onPressed: () => viewModel.tryChangePhoto(false),
                      child: const Text("Get from gallery"))
                ],
              ),
            ),
          );
        });
  }

  static Widget create(User? profileUser) => ChangeNotifierProvider<_ViewModel>(
      create: (context) =>
          _ViewModel(context: context, profileUser: profileUser),
      child: const ProfileWidget());
}
