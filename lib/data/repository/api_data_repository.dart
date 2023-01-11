import 'dart:io';

import 'package:courseproject_ui_dd2022/data/clients/api_client.dart';
import 'package:courseproject_ui_dd2022/domain/models/attach_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_comment_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/comment_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_post_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_user_model.dart';

import '../../domain/models/create_models/create_reaction_model.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/refresh_token_request.dart';
import '../../domain/models/user.dart';
import '../../domain/repository/api_repository.dart';
import '../../domain/models/token_request.dart';
import '../../domain/models/token_response.dart';
import '../clients/auth_client.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  @override
  Future<TokenResponse?> getToken({
    required String login,
    required String password,
  }) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      password: password,
    ));
  }

  @override
  Future<User?> getCurrentUser() async {
    return await _api.getCurrentUser();
  }

  @override
  Future<User?> getUserById(String userId) async {
    return await _api.getUserById(userId);
  }

  @override
  Future<TokenResponse?> refreshToken({required String token}) async {
    return await _auth.refreshToken(RefreshTokenRequest(token: token));
  }

  @override
  Future<List<PostModel>> getPostsForUser(
          String userId, int amount, int skip) async =>
      _api.getPostsForUser(userId, amount, skip);

  @override
  Future addAvatarForUser(AttachModel model) async =>
      _api.addAvatarForUser(model);

  @override
  Future<List<AttachModel>> uploadFiles({required List<File> files}) async =>
      _api.uploadFiles(files: files);

  @override
  Future createUser(CreateUserModel model) async => _auth.createUser(model);

  @override
  Future createPost(CreatePostModel model) async => _api.createPost(model);

  @override
  Future createComment(String postId, CreateCommentModel model) async =>
      _api.createComment(postId, model);

  @override
  Future<List<CommentModel>> getPostComments(String postId) async =>
      _api.getPostComments(postId);

  @override
  Future createReactionOnPost(String postId, CreateReactionModel model) async =>
      _api.createReactionOnPost(postId, model);

  @override
  Future<int> getUserReactionOnPost(String postId) async =>
      _api.getUserReactionOnPost(postId);

  @override
  Future removeReactionFromPost(String postId) async =>
      _api.removeReactionFromPost(postId);

  @override
  Future removeComment(String commentId) async =>
      _api.removeCommentFromPost(commentId);

  @override
  Future removePost(String postId) async => _api.removePost(postId);

  @override
  Future getIsSubscribedToUser(String targetId) async =>
      _api.getIsSubscribedToTarget(targetId);

  @override
  Future subscribeTo(String targetId) async => _api.subscribeTo(targetId);
  @override
  Future unsubscribeFrom(String targetId) async =>
      _api.unsubscribeFrom(targetId);
}
