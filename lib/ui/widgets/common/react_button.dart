import 'package:courseproject_ui_dd2022/data/service/data_service.dart';
import 'package:courseproject_ui_dd2022/domain/enums/reactions.dart';
import 'package:courseproject_ui_dd2022/domain/models/comment_model.dart';
import 'package:courseproject_ui_dd2022/internal/dependencies/repository_module.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/comment.dart';
import '../../../domain/models/create_models/create_reaction_model.dart';
import '../../../domain/models/post.dart';
import '../../../domain/models/post_model.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class PostReactButtonWidget extends StatelessWidget {
  const PostReactButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<PostReactButtonModel>();

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

  static ChangeNotifierProvider<PostReactButtonModel> create(
          BuildContext bc, PostModel? post) =>
      ChangeNotifierProvider<PostReactButtonModel>(
          create: (context) => PostReactButtonModel(context: bc, post: post),
          child: const PostReactButtonWidget());
}

class CommentReactButtonWidget extends StatelessWidget {
  const CommentReactButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CommentReactButtonModel>();

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
      Text(viewModel.thisComment!.reactionsCount.toString())
    ]);
  }

  static ChangeNotifierProvider<CommentReactButtonModel> create(
          BuildContext bc, CommentModel? comment) =>
      ChangeNotifierProvider<CommentReactButtonModel>(
          create: (context) =>
              CommentReactButtonModel(context: bc, comment: comment),
          child: const CommentReactButtonWidget());
}

abstract class ReactButtonModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  BuildContext? myContext;

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

  void asyncInit() async {}
  Future removeReaction() async {}
  Future addReaction(ReactionType reaction) async {}
  Future update() async {}
  void afterRemove() {}
  void afterAdd(ReactionType newReaction) {}

  void showReactionPicker() {
    ReactionType reaction;
    if (currentReaction != null) {
      isLoaded = false;
      Future.wait([removeReaction()]).then((value) {
        afterRemove();
        update();
      });

      return;
    }
    showDialog(
        useRootNavigator: false,
        context: myContext!,
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
                        Future.wait([addReaction(reaction), update()])
                            .then((value) {
                          afterAdd(reaction);
                        });
                      },
                    ),
                    itemCount: ReactionType.values.length,
                  ))
            ])));
  }
}

class PostReactButtonModel extends ReactButtonModel {
  PostModel? thisPost;

  PostReactButtonModel(
      {required BuildContext context, required PostModel? post}) {
    myContext = context;
    thisPost = post;
    asyncInit();
  }

  @override
  void asyncInit() async {
    var tempReaction =
        await _api.getUserReactionOnPost(thisPost!.id).then((value) {
      isLoaded = true;
      return value;
    });
    currentReaction =
        tempReaction != -1 ? ReactionHelper.intToReaction(tempReaction) : null;
  }

  @override
  Future update() async {
    var post = Post.fromJson(thisPost!.toJson())
        .copyWith(authorId: thisPost!.author.id);
    await DataService().rangeUpdateEntities<Post>([post]);
  }

  @override
  Future removeReaction() async {
    _api.removeReactionFromPost(thisPost!.id);
  }

  @override
  void afterAdd(ReactionType newReaction) {
    currentReaction = newReaction;
    thisPost!.reactionsCount++;
    Navigator.of(myContext!).pop();
    isLoaded = true;
  }

  @override
  void afterRemove() {
    currentReaction = null;
    thisPost!.reactionsCount--;
    isLoaded = true;
  }

  @override
  Future addReaction(ReactionType reaction) async {
    _api.createReactionOnPost(
        thisPost!.id, CreateReactionModel(reactionType: reaction.index));
  }
}

class CommentReactButtonModel extends ReactButtonModel {
  CommentModel? thisComment;

  CommentReactButtonModel(
      {required BuildContext context, required CommentModel? comment}) {
    thisComment = comment;
    myContext = context;
    asyncInit();
  }

  @override
  void asyncInit() async {
    var tempReaction =
        await _api.getUserReactionOnComment(thisComment!.id).then((value) {
      isLoaded = true;
      return value;
    });
    currentReaction =
        tempReaction != -1 ? ReactionHelper.intToReaction(tempReaction) : null;
  }

  @override
  Future update() async {
    var comment = Comment.fromJson(thisComment!.toJson())
        .copyWith(authorId: thisComment!.author.id);
    await DataService().rangeUpdateEntities<Comment>([comment]);
  }

  @override
  Future removeReaction() async {
    _api.removeReactionFromComment(thisComment!.id);
  }

  @override
  void afterAdd(ReactionType newReaction) {
    currentReaction = newReaction;
    thisComment!.reactionsCount++;
    Navigator.of(myContext!).pop();
    isLoaded = true;
  }

  @override
  void afterRemove() {
    currentReaction = null;
    thisComment!.reactionsCount--;
    isLoaded = true;
  }

  @override
  Future addReaction(ReactionType reaction) async {
    _api.createReactionOnComment(
        thisComment!.id, CreateReactionModel(reactionType: reaction.index));
  }
}
