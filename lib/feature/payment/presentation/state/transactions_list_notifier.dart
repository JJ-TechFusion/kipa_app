import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction_list_entity.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../providers/payment_provider.dart';
import 'transactions_list_state.dart';

class TransactionsListNotifier extends Notifier<TransactionsListState> {
  @override
  TransactionsListState build() => const TransactionsListState();

  GetTransactionsUseCase get _useCase =>
      ref.read(getTransactionsUseCaseProvider);

  Future<void> fetchTransactions({String? status}) async {
    state = state.copyWith(isFetching: true, errorMessage: null);

    final filterStatus = status ?? state.selectedFilter;
    final queryStatus = filterStatus == 'all' ? null : filterStatus;

    final response = await _useCase(status: queryStatus);

    if (response.success && response.data != null) {
      state = state.copyWith(
        transactions: response.data as List<TransactionListItemEntity>,
        isFetching: false,
      );
    } else {
      state = state.copyWith(isFetching: false, errorMessage: response.message);
    }
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
    fetchTransactions(status: filter);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
