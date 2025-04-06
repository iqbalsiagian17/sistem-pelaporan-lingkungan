import 'package:bb_mobile/features/parameter/domain/entities/parameter_entity.dart';

abstract class ParameterRepository {
  Future<ParameterEntity> getParameter();
}
