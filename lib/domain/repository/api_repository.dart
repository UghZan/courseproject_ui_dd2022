import 'dart:io';

import 'package:courseproject_ui_dd2022/domain/models/create_models/create_post_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_user_model.dart';

import '../models/attach_model.dart';
import '../models/comment_model.dart';
import '../models/create_models/create_comment_model.dart';
import '../models/post_model.dart';
import '../models/token_response.dart';
import '../models/user.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});
  Future<TokenResponse?> refreshToken({required String token});

  Future<User?> getCurrentUser();
  Future createUser(CreateUserModel model);
  Future addAvatarForUser(AttachModel model);

  Future createPost(CreatePostModel model);
  Future<List<PostModel>> getPosts(int amount, int skip);

  Future<List<AttachModel>> uploadFiles({required List<File> files});

  Future createComment(String postId, CreateCommentModel model);

  Future<List<CommentModel>> getPostComments(String postId);
}
