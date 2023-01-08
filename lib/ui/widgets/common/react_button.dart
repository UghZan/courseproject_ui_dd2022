import 'package:courseproject_ui_dd2022/data/service/data_service.dart';
import 'package:courseproject_ui_dd2022/domain/enums/reactions.dart';
import 'package:courseproject_ui_dd2022/internal/dependencies/repository_module.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/create_models/create_reaction_model.dart';
import '../../../domain/models/post.dart';
import '../../../domain/models/post_model.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class ReactButtonWidget extends StatelessWidget {
  const ReactButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ReactButtonModel>();

    if (!viewModel.isLoaded) return const CircularProgressIndicator();
    return Row(children: [
      IconButton(
          onPressed: () => viewModel.showReactionPicker(),
          icon: viewModel.currentReaction == null
              ? const Icon(Icons.favorite)
              : CircleAvatar(
                  radius: 32,
                  foregroundImage: Image.asset(ReactionHelper.reactionImagePath(
                          viewModel.currentReaction!))
                      .image,
                )),
      Text(viewModel.thisPost!.reactionsCount.toString())
    ]);
  }

  static ChangeNotifierProvider<ReactButtonModel> create(
          BuildContext bc, PostModel? post) =>
      ChangeNotifierProvider<ReactButtonModel>(
          create: (context) => ReactButtonModel(context: bc, post: post),
          child: const ReactButtonWidget());
}

class ReactButtonModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();

  ReactionType? _currentReaction;
  ReactionType? get currentReaction => _currentReaction;
  set currentReaction(ReactionType? newState) {
    _currentReaction = newState;
    notifyListeners();
  }

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  set isLoaded(bool newState) {
    _isLoaded = newState;
    notifyListeners();
  }

  PostModel? thisPost;

  BuildContext context;

  ReactButtonModel({required this.context, required PostModel? post}) {
    thisPost = post;
    asyncInit();
  }

  void asyncInit() async {
    var tempReaction =
        await _api.getUserReactionOnPost(thisPost!.id).then((value) {
      isLoaded = true;
      return value;
    });
    currentReaction =
        tempReaction != -1 ? ReactionHelper.intToReaction(tempReaction) : null;
  }

  Future updatePostInDB() async {
    var post = Post.fromJson(thisPost!.toJson())
        .copyWith(authorId: thisPost!.author.id);
    await DataService().rangeUpdateEntities<Post>([post]);
  }

  void showReactionPicker() {
    ReactionType reaction;
    if (currentReaction != null) {
      isLoaded = false;
      Future.wait([
        RepositoryModule.apiRepository().removeReactionFromPost(thisPost!.id),
        updatePostInDB()
      ]).then((value) {
        currentReaction = null;
        thisPost!.reactionsCount--;
        isLoaded = true;
      });

      return;
    }
    showDialog(
        context: context,
        builder: (context) => Dialog(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text("Choose a reaction", style: TextStyle(fontSize: 24)),
              SizedBox(
                  height: 50,
                  width: 500,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => IconButton(
                      icon: Image.asset(
                        ReactionHelper.reactionImagePath(
                            ReactionType.values[index]),
                        width: 32,
                        height: 32,
                      ),
                      onPressed: () async {
                        isLoaded = false;
                        reaction = ReactionType.values[index];
                        Future.wait([
                          RepositoryModule.apiRepository().createReactionOnPost(
                              thisPost!.id,
                              CreateReactionModel(
                                  reactionType: reaction.index)),
                          updatePostInDB()
                        ]).then((value) {
                          currentReaction = reaction;
                          thisPost!.reactionsCount++;
                          Navigator.of(context).pop();
                          isLoaded = true;
                        });
                      },
                    ),
                    itemCount: ReactionType.values.length,
                  ))
            ])));
  }
}
