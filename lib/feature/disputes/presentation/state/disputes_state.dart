import '../../domain/entities/dispute_entity.dart';

class DisputesState {
  final bool isFetchingDisputes;
  final bool isFetchingDisputeDetail;
  final String? errorMessage;
  final List<DisputeEntity>? disputes;
  final int? count;
  final DisputeEntity? disputeDetail;

  const DisputesState({
    this.isFetchingDisputes = false,
    this.isFetchingDisputeDetail = false,
    this.errorMessage,
    this.disputes,
    this.count,
    this.disputeDetail,
  });

  DisputesState copyWith({
    bool? isFetchingDisputes,
    bool? isFetchingDisputeDetail,
    String? errorMessage,
    List<DisputeEntity>? disputes,
    int? count,
    DisputeEntity? disputeDetail,
  }) {
    return DisputesState(
      isFetchingDisputes: isFetchingDisputes ?? this.isFetchingDisputes,
      isFetchingDisputeDetail:
          isFetchingDisputeDetail ?? this.isFetchingDisputeDetail,
      errorMessage: errorMessage,
      disputes: disputes ?? this.disputes,
      count: count ?? this.count,
      disputeDetail: disputeDetail ?? this.disputeDetail,
    );
  }
}
