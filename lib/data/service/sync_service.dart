import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../../internal/dependencies/repository_module.dart';
import 'data_service.dart';

class SyncService {
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  Future syncPosts() async {
    _dataService.clearDB();

    var postModels = await _api.getPosts(100, 0);
    var authors = postModels.map((e) => e.author).toSet();
    var postAttachments = postModels
        .expand((element) =>
            element.postAttachments.map((e) => e.copyWith(postId: element.id)))
        .toList();
    var posts = postModels
        .map((e) => Post.fromJson(e.toJson()).copyWith(authorId: e.author.id));

    await _dataService.rangeUpdateEntities(authors);
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
