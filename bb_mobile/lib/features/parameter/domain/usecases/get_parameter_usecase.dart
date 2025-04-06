import 'package:bb_mobile/features/parameter/domain/entities/parameter_entity.dart';
import 'package:bb_mobile/features/parameter/domain/repositories/parameter_repository.dart';

class GetParameterUseCase {
  final ParameterRepository repository;

  GetParameterUseCase({required this.repository});

  Future<ParameterEntity> call() async {
    return await repository.getParameter();
  }
}
