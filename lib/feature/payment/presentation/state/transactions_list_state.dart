import 'package:flutter/foundation.dart';
import '../../domain/entities/transaction_list_entity.dart';

@immutable
class TransactionsListState {
  final List<TransactionListItemEntity>? transactions;
  final bool isFetching;
  final String? errorMessage;
  final String selectedFilter;

  const TransactionsListState({
    this.transactions,
    this.isFetching = false,
    this.errorMessage,
    this.selectedFilter = 'all',
  });

  TransactionsListState copyWith({
    List<TransactionListItemEntity>? transactions,
    bool? isFetching,
    String? errorMessage,
    String? selectedFilter,
  }) {
    return TransactionsListState(
      transactions: transactions ?? this.transactions,
      isFetching: isFetching ?? this.isFetching,
      errorMessage: errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
