import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class LikeForumPostUseCase {
  final ForumRepository repository;

  LikeForumPostUseCase({required this.repository});

  Future<bool> call(int postId) async {
    return await repository.likePost(postId);
  }
}
