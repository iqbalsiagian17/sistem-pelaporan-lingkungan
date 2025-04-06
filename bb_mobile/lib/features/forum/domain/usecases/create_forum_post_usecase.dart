import 'package:bb_mobile/features/forum/domain/repositories/forum_repository.dart';

class CreateForumPostUseCase {
  final ForumRepository repository;

  CreateForumPostUseCase({required this.repository});

  Future<bool> call({
    required String content,
    required List<String> imagePaths,
  }) async {
    return await repository.createPost(content: content, imagePaths: imagePaths);
  }
}
