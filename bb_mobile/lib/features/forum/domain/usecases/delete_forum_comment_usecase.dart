import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class DeleteForumCommentUseCase {
  final ForumRepository repository;

  DeleteForumCommentUseCase({required this.repository});

  Future<bool> call(int commentId) async {
    return await repository.deleteComment(commentId);
  }
}
