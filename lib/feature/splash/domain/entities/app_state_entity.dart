class AppStateEntity {
  final bool isFirstTime;
  final bool isAuthenticated;
  final bool needsProfileCompletion;

  const AppStateEntity({
    required this.isFirstTime,
    required this.isAuthenticated,
    this.needsProfileCompletion = false,
  });
}
