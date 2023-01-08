import 'package:courseproject_ui_dd2022/domain/enums/reactions.dart';
import 'package:courseproject_ui_dd2022/internal/dependencies/repository_module.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/create_models/create_reaction_model.dart';
import '../../../domain/models/post_model.dart';

class ReactButton extends StatefulWidget {
  final PostModel? _post;
  const ReactButton(Key? key, this._post) : super(key: key);
  @override
  createState() => ReactButtonState();
}

class ReactButtonState extends State<ReactButton> {
  final _api = RepositoryModule.apiRepository();
  ReactionType? currentReaction;
  int reactions = 0;

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    var tempReaction = await _api.getUserReactionOnPost(widget._post!.id);
    currentReaction =
        tempReaction != -1 ? ReactionHelper.intToReaction(tempReaction) : null;
    reactions = widget._post!.reactionsCount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
          onPressed: () => showReactionPicker(),
          icon: currentReaction == null
              ? const Icon(Icons.favorite)
              : CircleAvatar(
                  radius: 32,
                  foregroundImage: Image.asset(
                          ReactionHelper.reactionImagePath(currentReaction!))
                      .image,
                )),
      Text(reactions.toString())
    ]);
  }

  void showReactionPicker() {
    ReactionType reaction;
    if (currentReaction != null) {
      RepositoryModule.apiRepository().removeReactionFromPost(widget._post!.id);
      setState(() {
        currentReaction = null;
        reactions--;
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
                        reaction = ReactionType.values[index];
                        await RepositoryModule.apiRepository()
                            .createReactionOnPost(
                                widget._post!.id,
                                CreateReactionModel(
                                    reactionType: reaction.index))
                            .then((value) {
                          setState(() {
                            currentReaction = reaction;
                            reactions++;
                          });
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    itemCount: ReactionType.values.length,
                  ))
            ])));
  }
}
