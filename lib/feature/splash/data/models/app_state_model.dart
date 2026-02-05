import '../../domain/entities/entities.dart';

class AppStateModel extends AppStateEntity {
  const AppStateModel({
    required super.isFirstTime,
    required super.isAuthenticated,
  });

  factory AppStateModel.fromEntity(AppStateEntity entity) {
    return AppStateModel(
      isFirstTime: entity.isFirstTime,
      isAuthenticated: entity.isAuthenticated,
    );
  }

  AppStateEntity toEntity() {
    return AppStateEntity(
      isFirstTime: isFirstTime,
      isAuthenticated: isAuthenticated,
    );
  }
}
