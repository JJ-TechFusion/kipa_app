import '../repositories/errand_repository.dart';

class CompleteErrandUsecase {
  final ErrandRepository _repository;

  CompleteErrandUsecase(this._repository);

  Future<void> call(String errandId, String dropoffCode) {
    return _repository.completeErrand(errandId, dropoffCode);
  }
}
