import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../data/wallet_repository.dart';
import '../data/models/transaction_model.dart';
import 'wallet_notifier.dart';

// Transactions Notifier using DataState
class TransactionsNotifier extends StateNotifier<DataState<TransactionModel>> {
  final WalletRepository _repository;

  TransactionsNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchTransactions({bool refresh = false}) async {
    if (refresh) {
      log('[TransactionsNotifier] Refreshing transactions');
      state = DataState.initial();
    } else {
      log('[TransactionsNotifier] Fetching transactions');
    }

    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getTransactions(page: 0, size: 20);
      log('[TransactionsNotifier] Successfully fetched ${response.payload.transactions.length} transactions');

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.payload.transactions,
        currentPage: int.tryParse(response.payload.currentPage) ?? 0,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[TransactionsNotifier] Error fetching transactions: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isPaginating || state.currentPage >= state.totalPages - 1) return;

    log('[TransactionsNotifier] Loading more transactions');

    state = state.copyWith(
      isPaginating: true,
      message: null,
    );

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.getTransactions(page: nextPage, size: 20);
      log('[TransactionsNotifier] Successfully loaded ${response.payload.transactions.length} more transactions');

      final updatedTransactions = [...?state.data, ...response.payload.transactions];

      state = state.copyWith(
        isPaginating: false,
        data: updatedTransactions,
        currentPage: int.tryParse(response.payload.currentPage) ?? nextPage,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[TransactionsNotifier] Error loading more transactions: $e\n$stack');
      state = state.copyWith(
        isPaginating: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  void reset() {
    state = DataState.initial();
  }
}

// Provider
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, DataState<TransactionModel>>(
  (ref) {
    final repository = ref.watch(walletRepositoryProvider);
    return TransactionsNotifier(repository);
  },
);
