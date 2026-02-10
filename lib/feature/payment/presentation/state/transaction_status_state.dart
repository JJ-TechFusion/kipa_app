import '../../domain/entities/transaction_status_entities.dart';

class TransactionStatusState {
  final bool isLoading;
  final String? errorMessage;
  final TransactionStatusEntity? transactionStatus;

  const TransactionStatusState({
    this.isLoading = false,
    this.errorMessage,
    this.transactionStatus,
  });

  TransactionStatusState copyWith({
    bool? isLoading,
    String? errorMessage,
    TransactionStatusEntity? transactionStatus,
  }) {
    return TransactionStatusState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      transactionStatus: transactionStatus ?? this.transactionStatus,
    );
  }
}
