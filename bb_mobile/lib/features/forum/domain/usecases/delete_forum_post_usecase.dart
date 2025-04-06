import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class DeleteForumPostUseCase {
  final ForumRepository repository;

  DeleteForumPostUseCase({required this.repository});

  Future<bool> call(int postId) async {
    return await repository.deletePost(postId);
  }
}
