import 'package:courseproject_ui_dd2022/domain/models/comment_model.dart';

import '../../domain/db_model.dart';
import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../../domain/models/post_photo.dart';
import '../../domain/models/post_model.dart';
import 'database.dart';
import '../../domain/models/user.dart';

class DataService {
  Future createOrUpdateUser(User user) async {
    await DB.instance.createUpdate(user);
  }

  Future rangeUpdateEntities<T extends DbModel>(Iterable<T> elems) async {
    await DB.instance.createUpdateRange(elems);
  }

  Future clearDB() async {
    await DB.instance.clearDB();
  }

  Future<List<PostModel>> getPosts() async {
    var res = <PostModel>[];
    var posts = await DB.instance.getAll<Post>();
    for (var post in posts) {
      var author = await DB.instance.get<User>(post.authorId);
      var attachs =
          (await DB.instance.getAll<PostPhoto>(whereMap: {"postId": post.id}))
              .toList();
      if (author != null) {
        res.add(PostModel(
            id: post.id,
            author: author,
            postAttachments: attachs,
            postContent: post.postContent,
            creationDate: post.creationDate,
            reactionsCount: post.reactionsCount,
            commentsCount: post.commentsCount));
      }
    }

    return res;
  }

  Future<List<CommentModel>> getCommentsForPost(String postId) async {
    var res = <CommentModel>[];
    var comments =
        (await DB.instance.getAll<Comment>(whereMap: {"postId": postId}))
            .toList();
    for (var comment in comments) {
      var author = await DB.instance.get<User>(comment.authorId);
      if (author != null) {
        res.add(CommentModel(
            id: comment.id,
            author: author,
            postContent: comment.postContent,
            creationDate: comment.creationDate,
            reactionsCount: comment.reactionsCount,
            postId: comment.postId));
      }
    }

    return res;
  }
}
