import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';

abstract class ForumRepository {
  Future<List<ForumPostEntity>> getAllPosts();
  Future<ForumPostEntity?> getPostById(int postId);
  Future<bool> createPost({required String content, required List<String> imagePaths});
  Future<bool> createComment({required int postId, required String content});
  Future<bool> deletePost(int postId);
  Future<bool> deleteComment(int commentId);

  Future<bool> likePost(int postId);
  Future<bool> unlikePost(int postId);
  Future<int> getLikeCount(int postId);

}
