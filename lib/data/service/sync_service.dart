import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';

import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../../domain/models/user.dart';
import '../../internal/dependencies/repository_module.dart';
import 'data_service.dart';
import 'database.dart';

class SyncService {
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  Future syncPosts() async {
    await DB.instance.cleanTable<Post>();

    var user = await SharedPrefs.getStoredUser();
    var postModels = await _api.getPostsForUser(user!.id, 100, 0);
    var authors = postModels.map((e) => e.author).toSet();
    var authorsSynced = <User>{};
    for (User u in authors) {
      var synced = await _api.getUserById(u.id);
      authorsSynced.add(synced ?? u);
    }
    var postAttachments = postModels
        .expand((element) =>
            element.postAttachments.map((e) => e.copyWith(postId: element.id)))
        .toList();
    var posts = postModels
        .map((e) => Post.fromJson(e.toJson()).copyWith(authorId: e.author.id));

    await _dataService.rangeUpdateEntities(authorsSynced);
    await _dataService.rangeUpdateEntities(posts);
    await _dataService.rangeUpdateEntities(postAttachments);
  }

  Future syncCommentsOnPost(String post) async {
    var commentModels = await _api.getPostComments(post);
    var authors = commentModels.map((e) => e.author).toSet();
    var comments = commentModels.map((e) => Comment.fromJson(e.toJson())
        .copyWith(authorId: e.author.id, postId: post));

    await _dataService.rangeUpdateEntities(authors);
    await _dataService.rangeUpdateEntities(comments);
  }
}
