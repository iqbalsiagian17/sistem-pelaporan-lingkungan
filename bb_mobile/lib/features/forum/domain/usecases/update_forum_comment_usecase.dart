import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class UpdateCommentUseCase {
  final ForumRepository repository;

  UpdateCommentUseCase({required this.repository});

  Future<bool> call({required int commentId, required String content}) async {
    return await repository.updateComment(commentId: commentId, content: content);
  }
}
