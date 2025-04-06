import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class GetAllForumPostsUseCase {
  final ForumRepository repository;

  GetAllForumPostsUseCase({required this.repository});

  Future<List<ForumPostEntity>> call() async {
    return await repository.getAllPosts();
  }
}
