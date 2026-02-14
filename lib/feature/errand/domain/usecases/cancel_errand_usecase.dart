import '../entities/errand_entity.dart';
import '../repositories/errand_repository.dart';

class CancelErrandUsecase {
  final ErrandRepository _repository;

  CancelErrandUsecase(this._repository);

  Future<CancellationResult> call(String errandId) {
    return _repository.cancelErrand(errandId);
  }
}
