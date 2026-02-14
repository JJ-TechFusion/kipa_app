import '../../domain/entities/errand_entity.dart';
import '../../domain/repositories/errand_repository.dart';
import '../datasources/errand_remote_datasource.dart';

class ErrandRepositoryImpl implements ErrandRepository {
  final ErrandRemoteDatasource _datasource;

  ErrandRepositoryImpl(this._datasource);

  @override
  Future<ErrandEntity> createErrand(CreateErrandParams params) {
    return _datasource.createErrand(params);
  }

  @override
  Future<ErrandEntity> getErrand(String id) {
    return _datasource.getErrand(id);
  }

  @override
  Future<ErrandEntity?> getActiveErrand() {
    return _datasource.getActiveErrand();
  }

  @override
  Future<List<ErrandEntity>> getErrands({
    String? status,
    int? limit,
    int? offset,
  }) {
    return _datasource.getErrands(
      status: status,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<ErrandEntity> confirmErrand(String id) {
    return _datasource.confirmErrand(id);
  }

  @override
  Future<void> completeErrand(String id, String dropoffCode) {
    return _datasource.completeErrand(id, dropoffCode);
  }

  @override
  Future<CancellationResult> cancelErrand(String id) {
    return _datasource.cancelErrand(id);
  }
}
