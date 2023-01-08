enum ReactionType { like, dislike, heart, laugh, angry, sad, woah }

class ReactionHelper {
  static ReactionType intToReaction(int index) {
    return ReactionType.values[index];
  }

  static String reactionImagePath(ReactionType reaction) {
    return "images/reaction_${reaction.name}.png";
  }
}
