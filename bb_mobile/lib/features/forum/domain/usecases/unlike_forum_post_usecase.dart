import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class UnlikeForumPostUseCase {
  final ForumRepository repository;

  UnlikeForumPostUseCase({required this.repository});

  Future<bool> call(int postId) async {
    return await repository.unlikePost(postId);
  }
}
