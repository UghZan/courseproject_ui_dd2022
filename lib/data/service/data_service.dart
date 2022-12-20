import '../../domain/db_model.dart';
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
    await DB.instance.deleteDB();
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
            creationDate: post.creationDate));
      }
    }

    return res;
  }
}
