import 'package:bb_mobile/features/forum/data/datasources/forum_remote_datasource.dart';
import 'package:bb_mobile/features/forum/data/repositories/forum_repository_impl.dart';
import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';
import 'package:bb_mobile/features/forum/domain/usecases/create_forum_comment_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/create_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/delete_forum_comment_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/delete_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/get_all_forum_posts_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/get_forum_post_by_id_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/like_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/unlike_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/get_forum_post_like_count_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Remote Data Source
final forumRemoteDataSourceProvider = Provider<ForumRemoteDataSource>((ref) {
  return ForumRemoteDataSourceImpl();
});

/// ✅ Repository
final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  final remote = ref.read(forumRemoteDataSourceProvider);
  return ForumRepositoryImpl(remoteDataSource: remote);
});

/// ✅ Forum Post Usecases
final getForumPostsUseCaseProvider = Provider<GetAllForumPostsUseCase>((ref) {
  return GetAllForumPostsUseCase(repository: ref.read(forumRepositoryProvider));
});

final getForumPostByIdUseCaseProvider = Provider<GetForumPostByIdUseCase>((ref) {
  return GetForumPostByIdUseCase(repository: ref.read(forumRepositoryProvider));
});

final createPostUseCaseProvider = Provider<CreateForumPostUseCase>((ref) {
  return CreateForumPostUseCase(repository: ref.read(forumRepositoryProvider));
});

final createCommentUseCaseProvider = Provider<CreateForumCommentUseCase>((ref) {
  return CreateForumCommentUseCase(repository: ref.read(forumRepositoryProvider));
});

final deletePostUseCaseProvider = Provider<DeleteForumPostUseCase>((ref) {
  return DeleteForumPostUseCase(repository: ref.read(forumRepositoryProvider));
});

final deleteCommentUseCaseProvider = Provider<DeleteForumCommentUseCase>((ref) {
  return DeleteForumCommentUseCase(repository: ref.read(forumRepositoryProvider));
});

/// ✅ Like / Unlike / Like Count Usecases
final likePostUseCaseProvider = Provider<LikeForumPostUseCase>((ref) {
  return LikeForumPostUseCase(repository: ref.read(forumRepositoryProvider));
});

final unlikePostUseCaseProvider = Provider<UnlikeForumPostUseCase>((ref) {
  return UnlikeForumPostUseCase(repository: ref.read(forumRepositoryProvider));
});

final getLikeCountUseCaseProvider = Provider<GetForumPostLikeCountUseCase>((ref) {
  return GetForumPostLikeCountUseCase(repository: ref.read(forumRepositoryProvider));
});
