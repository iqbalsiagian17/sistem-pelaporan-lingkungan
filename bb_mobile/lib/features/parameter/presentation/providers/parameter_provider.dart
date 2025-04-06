import 'package:bb_mobile/features/parameter/domain/usecases/get_parameter_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/parameter/domain/entities/parameter_entity.dart';
import 'package:bb_mobile/features/parameter/presentation/providers/usecase_providers.dart';

final parameterNotifierProvider =
    StateNotifierProvider<ParameterNotifier, AsyncValue<ParameterEntity>>((ref) {
  final getParameterUseCase = ref.read(getParameterUseCaseProvider);
  return ParameterNotifier(getParameterUseCase);
});

class ParameterNotifier extends StateNotifier<AsyncValue<ParameterEntity>> {
  final GetParameterUseCase _getParameterUseCase;

  ParameterNotifier(this._getParameterUseCase) : super(const AsyncLoading()) {
    fetchParameter();
  }

  Future<void> fetchParameter() async {
    state = const AsyncLoading();
    try {
      final result = await _getParameterUseCase.call();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
