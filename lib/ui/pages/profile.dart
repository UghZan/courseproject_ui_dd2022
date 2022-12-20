// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../domain/models/user.dart';
import '../../internal/app_config.dart';
import '../../internal/dependencies/repository_module.dart';
import '../common/camera_widget.dart';
import 'app.dart';

class _ViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  BuildContext context;

  _ViewModel({required this.context, required User profileUser}) {
    this.profileUser = profileUser;
    asyncInit();
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

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  Future tryChangePhoto(bool camera) async {
    if (_visitorUser != _profileUser) return;

    var appViewData = context.read<AppViewModel>();

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
      var t = await _api.uploadFiles(files: [imageFile]);
      if (t.isNotEmpty) {
        await _api.addAvatarForUser(t.first);
        //re-obtain user with correct avatar
        visitorUser = await _api.getCurrentUser();
        //ensure that all logic still works and considers this *our* profile
        profileUser = visitorUser;
        appViewData.setAvatar(Image.file(imageFile));

        var img = await NetworkAssetBundle(
                Uri.parse("$baseUrl${visitorUser!.linkToAvatar}"))
            .load("$baseUrl${visitorUser!.linkToAvatar}?v=1");
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
    avatar = await getAvatar();
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.profileUser!.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                              child: Container(
                                  height: size.width,
                                  child: viewModel.avatar))),
                      Text(
                        viewModel.profileUser!.name,
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
              Text(viewModel.profileUser!.email,
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
                  "User for ${DateTime.now().difference(DateTime.tryParse(viewModel.profileUser!.createDate)!).inDays} days",
                  style: const TextStyle(
                      fontSize: 24, fontStyle: FontStyle.italic)),
            ],
          ),
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

  static Widget create(BuildContext buildContext, User user) =>
      ChangeNotifierProvider<_ViewModel>(
          create: (context) =>
              _ViewModel(context: buildContext, profileUser: user),
          child: const ProfileWidget());
}
