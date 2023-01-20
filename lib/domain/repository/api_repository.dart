import 'dart:io';

import 'package:courseproject_ui_dd2022/domain/models/create_models/create_post_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_user_model.dart';

import '../models/attach_model.dart';
import '../models/comment_model.dart';
import '../models/create_models/create_comment_model.dart';
import '../models/create_models/create_reaction_model.dart';
import '../models/post_model.dart';
import '../models/token_response.dart';
import '../models/user.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});
  Future<TokenResponse?> refreshToken({required String token});

  Future<User?> getCurrentUser();
  Future<User?> getUserById(String userId);
  Future createUser(CreateUserModel model);
  Future addAvatarForUser(AttachModel model);

  Future createPost(CreatePostModel model);
  Future<List<PostModel>> getPostsForUser(String userId, int amount, int skip);
  Future<List<User>> searchUsers(String query);

  Future<List<AttachModel>> uploadFiles({required List<File> files});

  Future createComment(String postId, CreateCommentModel model);

  Future<List<CommentModel>> getPostComments(String postId);

  Future createReactionOnPost(String postId, CreateReactionModel model);
  Future createReactionOnComment(String commentId, CreateReactionModel model);

  Future<int> getUserReactionOnPost(String postId);
  Future<int> getUserReactionOnComment(String commentId);

  Future removeReactionFromPost(String postId);
  Future removeReactionFromComment(String commentId);
  Future removeComment(String commentId);
  Future removePost(String postId);

  Future getIsSubscribedToUser(String targetId);
  Future subscribeTo(String targetId);
  Future unsubscribeFrom(String targetId);
}
