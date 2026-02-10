import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_transaction_status_usecase.dart';
import '../providers/payment_provider.dart';
import 'transaction_status_state.dart';
import '../../domain/entities/transaction_status_entities.dart';

class TransactionStatusNotifier extends Notifier<TransactionStatusState> {
  late final GetTransactionStatusUseCase _getTransactionStatusUseCase;

  @override
  TransactionStatusState build() {
    _getTransactionStatusUseCase = ref.read(
      getTransactionStatusUseCaseProvider,
    );
    return const TransactionStatusState();
  }

  Future<void> fetchTransactionStatus(String paymentRequestId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _getTransactionStatusUseCase(paymentRequestId);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isLoading: false,
          transactionStatus: response.data as TransactionStatusEntity,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
