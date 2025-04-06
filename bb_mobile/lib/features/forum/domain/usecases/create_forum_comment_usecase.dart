import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class CreateForumCommentUseCase {
  final ForumRepository repository;

  CreateForumCommentUseCase({required this.repository});

  Future<bool> call({
    required int postId,
    required String content,
  }) async {
    return await repository.createComment(postId: postId, content: content);
  }
}
