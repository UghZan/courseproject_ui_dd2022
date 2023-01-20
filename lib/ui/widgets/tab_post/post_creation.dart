// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:courseproject_ui_dd2022/domain/enums/tab_item.dart';
import 'package:courseproject_ui_dd2022/domain/models/attach_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_post_model.dart';
import 'package:courseproject_ui_dd2022/ui/widgets/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../internal/dependencies/repository_module.dart';
import '../common/camera_widget.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _api = RepositoryModule.apiRepository();
  bool isCreating = false;

  _ViewModel({required this.context}) {
    postController.addListener(() {
      postContent = postController.text;
    });
  }
  String? postContent;
  List<File>? postAttachments;

  TextEditingController postController = TextEditingController();

  void createPost() async {
    AppViewModel appViewModel = context.read<AppViewModel>();

    List<AttachModel> attachments = List.empty();
    if (postAttachments != null) {
      attachments = await _api.uploadFiles(files: postAttachments!);
    }

    var newPost = CreatePostModel(
        postContent: postContent!, postAttachments: attachments);
    isCreating = true;
    await _api.createPost(newPost).then((value) {
      FocusScope.of(context).unfocus();
      reset();
      appViewModel.selectTab(TabItemEnum.home);
      appViewModel.msg = "New post successfully created";
      isCreating = false;
    });
  }

  void reset() {
    postController.text = "";
    postAttachments?.clear();
  }

  Future<void> addAttachment(bool camera) async {
    postAttachments ??= List.empty(growable: true);
    if (postAttachments?.length == 10) return;

    String? imagePath;
    File? imageFile;

    //I would love to separate this into a thing available to every widget, but have no idea how to do that for now
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
    if (imageFile != null) postAttachments!.add(imageFile);
    notifyListeners();
  }
}

class PostCreateWidget extends StatelessWidget {
  const PostCreateWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
        appBar: AppBar(title: const Text("New post..."), actions: [
          IconButton(
              onPressed: () => viewModel.createPost(),
              icon: const Icon(Icons.check))
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _cameraGalleryPicker(context, viewModel),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(children: [
                viewModel.isCreating
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: TextField(
                        controller: viewModel.postController,
                        expands: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                            hintText: "Enter post text..."),
                      )),
                viewModel.postAttachments?.isEmpty ?? true
                    ? const SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(2),
                          itemBuilder: (context, index) {
                            var attaches = viewModel.postAttachments!;
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  attaches[index],
                                  height: 100,
                                  width: 100,
                                ));
                          },
                          itemCount: viewModel.postAttachments?.length ?? 0,
                        ),
                      )
              ])),
        ));
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
                      onPressed: () => viewModel
                          .addAttachment(true)
                          .then((value) => Navigator.pop(context)),
                      child: const Text("Take a picture")),
                  TextButton(
                      onPressed: () => viewModel
                          .addAttachment(false)
                          .then((value) => Navigator.pop(context)),
                      child: const Text("Get from gallery"))
                ],
              ),
            ),
          );
        });
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const PostCreateWidget());
}
