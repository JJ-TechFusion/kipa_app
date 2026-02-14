import '../entities/errand_entity.dart';
import '../repositories/errand_repository.dart';

class GetErrandUsecase {
  final ErrandRepository _repository;

  GetErrandUsecase(this._repository);

  Future<ErrandEntity> call(String errandId) {
    return _repository.getErrand(errandId);
  }
}
