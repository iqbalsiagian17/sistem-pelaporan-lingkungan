import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class UpdateForumPostUseCase {
  final ForumRepository repository;

  UpdateForumPostUseCase({required this.repository});

  Future<bool> call({
    required int postId,
    required String content,
    required List<String> imagePaths,
  }) async {
    return await repository.updatePost(
      postId: postId,
      content: content,
      imagePaths: imagePaths,
    );
  }
}
