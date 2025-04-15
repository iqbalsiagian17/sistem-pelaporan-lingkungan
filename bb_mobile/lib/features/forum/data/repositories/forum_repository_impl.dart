import 'package:bb_mobile/features/forum/data/datasources/forum_remote_datasource.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class ForumRepositoryImpl implements ForumRepository {
  final ForumRemoteDataSource remoteDataSource;

  ForumRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ForumPostEntity>> getAllPosts() async {
    final result = await remoteDataSource.getAllPosts();
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ForumPostEntity?> getPostById(int postId) async {
    final result = await remoteDataSource.getPostById(postId);
    return result?.toEntity();
  }

  @override
  Future<bool> createPost({required String content, required List<String> imagePaths}) {
    return remoteDataSource.createPost(content: content, imagePaths: imagePaths);
  }

  @override
  Future<bool> updatePost({required int postId, required String content, required List<String> imagePaths,}) {
    return remoteDataSource.updatePost(postId: postId, content: content, imagePaths: imagePaths);
  }
@override
Future<bool> updateComment({required int commentId, required String content}) {
  return remoteDataSource.updateComment(commentId: commentId, content: content);
}


  @override
  Future<bool> createComment({required int postId, required String content}) {
    return remoteDataSource.createComment(postId: postId, content: content);
  }

  @override
  Future<bool> deletePost(int postId) {
    return remoteDataSource.deletePost(postId);
  }

  @override
  Future<bool> deleteComment(int commentId) {
    return remoteDataSource.deleteComment(commentId);
  }

  @override
  Future<bool> likePost(int postId) {
    return remoteDataSource.likePost(postId);
  }

  @override
  Future<bool> unlikePost(int postId) {
    return remoteDataSource.unlikePost(postId);
  }

  @override
  Future<int> getLikeCount(int postId) {
    return remoteDataSource.getLikeCount(postId);
  }
}
