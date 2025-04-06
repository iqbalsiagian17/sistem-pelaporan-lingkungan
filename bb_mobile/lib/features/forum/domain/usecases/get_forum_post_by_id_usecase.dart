import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class GetForumPostByIdUseCase {
  final ForumRepository repository;

  GetForumPostByIdUseCase({required this.repository});

  Future<ForumPostEntity?> call(int postId) async {
    return await repository.getPostById(postId);
  }
}
