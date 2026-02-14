import '../entities/errand_entity.dart';
import '../repositories/errand_repository.dart';

class CreateErrandUsecase {
  final ErrandRepository _repository;

  CreateErrandUsecase(this._repository);

  Future<ErrandEntity> call(CreateErrandParams params) {
    return _repository.createErrand(params);
  }
}
