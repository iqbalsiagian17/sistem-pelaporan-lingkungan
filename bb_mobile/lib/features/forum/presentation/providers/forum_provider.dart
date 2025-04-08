import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/domain/usecases/create_forum_comment_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/create_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/delete_forum_comment_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/delete_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/get_all_forum_posts_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/get_forum_post_by_id_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/like_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/unlike_forum_post_usecase.dart';
import 'package:bb_mobile/features/forum/domain/usecases/get_forum_post_like_count_usecase.dart';
import 'package:bb_mobile/features/forum/presentation/providers/usecase_providers.dart';

final forumProvider = StateNotifierProvider<ForumNotifier, ForumState>((ref) {
  return ForumNotifier(
    getPostsUseCase: ref.read(getForumPostsUseCaseProvider),
    getPostByIdUseCase: ref.read(getForumPostByIdUseCaseProvider),
    createPostUseCase: ref.read(createPostUseCaseProvider),
    createCommentUseCase: ref.read(createCommentUseCaseProvider),
    deletePostUseCase: ref.read(deletePostUseCaseProvider),
    deleteCommentUseCase: ref.read(deleteCommentUseCaseProvider),
    likePostUseCase: ref.read(likePostUseCaseProvider),
    unlikePostUseCase: ref.read(unlikePostUseCaseProvider),
    getLikeCountUseCase: ref.read(getLikeCountUseCaseProvider),
  );
});

class ForumState {
  final List<ForumPostEntity> posts;
  final ForumPostEntity? selectedPost;
  final bool isLoading;
  final String? errorMessage;

  const ForumState({
    this.posts = const [],
    this.selectedPost,
    this.isLoading = false,
    this.errorMessage,
  });

  ForumState copyWith({
    List<ForumPostEntity>? posts,
    ForumPostEntity? selectedPost,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ForumState(
      posts: posts ?? this.posts,
      selectedPost: selectedPost ?? this.selectedPost,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ForumNotifier extends StateNotifier<ForumState> {
  final GetAllForumPostsUseCase getPostsUseCase;
  final GetForumPostByIdUseCase getPostByIdUseCase;
  final CreateForumPostUseCase createPostUseCase;
  final CreateForumCommentUseCase createCommentUseCase;
  final DeleteForumPostUseCase deletePostUseCase;
  final DeleteForumCommentUseCase deleteCommentUseCase;
  final LikeForumPostUseCase likePostUseCase;
  final UnlikeForumPostUseCase unlikePostUseCase;
  final GetForumPostLikeCountUseCase getLikeCountUseCase;

  ForumNotifier({
    required this.getPostsUseCase,
    required this.getPostByIdUseCase,
    required this.createPostUseCase,
    required this.createCommentUseCase,
    required this.deletePostUseCase,
    required this.deleteCommentUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.getLikeCountUseCase,
  }) : super(const ForumState());

  Future<void> fetchAllPosts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await getPostsUseCase.call();
      state = state.copyWith(posts: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchPostById(int postId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final post = await getPostByIdUseCase.call(postId);
      if (post != null) {
        state = state.copyWith(selectedPost: post, isLoading: false);
      } else {
        state = state.copyWith(errorMessage: 'Post tidak ditemukan', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> createPost({required String content, required List<String> imagePaths}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await createPostUseCase.call(content: content, imagePaths: imagePaths);
      if (result) await fetchAllPosts();
      return result;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> addComment({required int postId, required String content}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await createCommentUseCase.call(postId: postId, content: content);
      if (result) await fetchPostById(postId);
      return result;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deletePost(int postId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await deletePostUseCase.call(postId);
      if (result) {
        final updatedPosts = state.posts.where((p) => p.id != postId).toList();
        state = state.copyWith(posts: updatedPosts, isLoading: false);
      }
      return result;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteComment(int commentId, int postId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await deleteCommentUseCase.call(commentId);
      if (result) await fetchPostById(postId);
      return result;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<void> likePost(int postId) async {
    try {
      await likePostUseCase.call(postId);
      final oldPost = state.posts.firstWhere((p) => p.id == postId, orElse: () => state.selectedPost!);
      updatePostLikeStatus(postId, true, oldPost.likeCount + 1);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> unlikePost(int postId) async {
    try {
      await unlikePostUseCase.call(postId);
      final oldPost = state.posts.firstWhere((p) => p.id == postId, orElse: () => state.selectedPost!);
      updatePostLikeStatus(postId, false, (oldPost.likeCount > 0 ? oldPost.likeCount - 1 : 0));
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }


  Future<int> getLikeCount(int postId) async {
    try {
      final count = await getLikeCountUseCase.call(postId);
      return count;
    } catch (e) {
      print(" [getLikeCount] Error: $e");
      state = state.copyWith(errorMessage: e.toString());
      return 0;
    }
  }


  void updatePostLikeStatus(int postId, bool isLiked, int likeCount) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(isLiked: isLiked, likeCount: likeCount);
      }
      return post;
    }).toList();

    ForumPostEntity? updatedSelected = state.selectedPost;
    if (updatedSelected != null && updatedSelected.id == postId) {
      updatedSelected = updatedSelected.copyWith(isLiked: isLiked, likeCount: likeCount);
    }

    state = state.copyWith(posts: updatedPosts, selectedPost: updatedSelected);
  }


  void clearState() {
    state = const ForumState();
  }
}
