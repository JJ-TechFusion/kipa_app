import '../entities/errand_entity.dart';
import '../repositories/errand_repository.dart';

class ConfirmErrandUsecase {
  final ErrandRepository _repository;

  ConfirmErrandUsecase(this._repository);

  Future<ErrandEntity> call(String errandId) {
    return _repository.confirmErrand(errandId);
  }
}
