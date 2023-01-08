import 'dart:io';

import 'package:courseproject_ui_dd2022/domain/models/comment_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_comment_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_post_model.dart';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_reaction_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../domain/models/attach_model.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetCurrentUser")
  Future<User?> getCurrentUser();

  @GET("/api/Post/GetCurrentUserPosts")
  Future<List<PostModel>> getPosts(
      @Query("amount") int amount, @Query("startingFrom") int skip);

  @POST("/api/Attach/UploadFiles")
  Future<List<AttachModel>> uploadFiles(
      {@Part(name: "files") required List<File> files});

  @POST("/api/User/AddAvatarForUser")
  Future addAvatarForUser(@Body() AttachModel newAvatar);

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel model);

  @POST("/api/Post/CreateCommentOnPost")
  Future createComment(
      @Query("postId") String postId, @Body() CreateCommentModel model);

  @GET("/api/Post/GetPostComments")
  Future<List<CommentModel>> getPostComments(@Query("postId") String postId);

  @POST("/api/Post/CreateReactionOnPost")
  Future createReactionOnPost(
      @Query("postId") String postId, @Body() CreateReactionModel model);

  @GET("/api/Post/GetCurrentUserPostReaction")
  Future<int> getUserReactionOnPost(@Query("postId") String postId);

  @DELETE("/api/Post/RemoveReactionFromPost")
  Future removeReactionFromPost(@Query("postId") String postId);
}
