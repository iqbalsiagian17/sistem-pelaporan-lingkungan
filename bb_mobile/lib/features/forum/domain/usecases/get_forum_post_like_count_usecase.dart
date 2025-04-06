import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class GetForumPostLikeCountUseCase {
  final ForumRepository repository;

  GetForumPostLikeCountUseCase({required this.repository});

  Future<int> call(int postId) async {
    return await repository.getLikeCount(postId);
  }
}
