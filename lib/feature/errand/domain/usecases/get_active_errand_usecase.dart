import '../entities/errand_entity.dart';
import '../repositories/errand_repository.dart';

class GetActiveErrandUsecase {
  final ErrandRepository _repository;

  GetActiveErrandUsecase(this._repository);

  Future<ErrandEntity?> call() {
    return _repository.getActiveErrand();
  }
}
