import '../entities/errand_entity.dart';

abstract class ErrandRepository {
  Future<ErrandEntity> createErrand(CreateErrandParams params);
  Future<ErrandEntity> getErrand(String id);
  Future<ErrandEntity?> getActiveErrand();
  Future<List<ErrandEntity>> getErrands({
    String? status,
    int? limit,
    int? offset,
  });
  Future<ErrandEntity> confirmErrand(String id);
  Future<void> completeErrand(String id, String dropoffCode);
  Future<CancellationResult> cancelErrand(String id);
}
