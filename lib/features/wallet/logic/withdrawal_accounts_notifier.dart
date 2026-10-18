import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/wallet_repository.dart';
import '../data/models/withdrawal_account_model.dart';
import 'wallet_notifier.dart'; // To get walletRepositoryProvider

final withdrawalAccountsProvider = StateNotifierProvider<WithdrawalAccountsNotifier, WithdrawalAccountsState>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return WithdrawalAccountsNotifier(repository)..fetchAccounts();
});

class WithdrawalAccountsState {
  final bool isLoading;
  final bool isActionLoading;
  final List<WithdrawalAccountModel> accounts;
  final String? errorMessage;
  final String? actionErrorMessage;

  const WithdrawalAccountsState({
    this.isLoading = false,
    this.isActionLoading = false,
    this.accounts = const [],
    this.errorMessage,
    this.actionErrorMessage,
  });

  factory WithdrawalAccountsState.initial() => const WithdrawalAccountsState();

  WithdrawalAccountsState copyWith({
    bool? isLoading,
    bool? isActionLoading,
    List<WithdrawalAccountModel>? accounts,
    String? errorMessage,
    String? actionErrorMessage,
    bool clearActionError = false,
  }) {
    return WithdrawalAccountsState(
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      accounts: accounts ?? this.accounts,
      errorMessage: errorMessage ?? this.errorMessage,
      actionErrorMessage: clearActionError ? null : (actionErrorMessage ?? this.actionErrorMessage),
    );
  }
}

class WithdrawalAccountsNotifier extends StateNotifier<WithdrawalAccountsState> {
  final WalletRepository _repository;

  WithdrawalAccountsNotifier(this._repository) : super(WithdrawalAccountsState.initial());

  Future<void> fetchAccounts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final accounts = await _repository.getWithdrawalAccounts();
      state = state.copyWith(isLoading: false, accounts: accounts);
    } catch (e) {
      log('[WithdrawalAccountsNotifier] Error fetching accounts: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> addAccount(WithdrawalAccountModel newAccount) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);
    try {
      final addedAccount = await _repository.addWithdrawalAccount(newAccount);
      final updatedAccounts = List<WithdrawalAccountModel>.from(state.accounts)..add(addedAccount);
      state = state.copyWith(isActionLoading: false, accounts: updatedAccounts);
      return true;
    } catch (e) {
      log('[WithdrawalAccountsNotifier] Error adding account: $e');
      state = state.copyWith(isActionLoading: false, actionErrorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteAccount(int id) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);
    try {
      await _repository.deleteWithdrawalAccount(id);
      final updatedAccounts = state.accounts.where((acc) => acc.id != id).toList();
      state = state.copyWith(isActionLoading: false, accounts: updatedAccounts);
      return true;
    } catch (e) {
      log('[WithdrawalAccountsNotifier] Error deleting account: $e');
      state = state.copyWith(isActionLoading: false, actionErrorMessage: e.toString());
      return false;
    }
  }

  Future<bool> makeDefault(int id) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);
    try {
      await _repository.makeDefaultWithdrawalAccount(id);
      // Optimistically update the UI to reflect the new default
      final updatedAccounts = state.accounts.map((acc) {
        if (acc.id == id) {
          return WithdrawalAccountModel(
            id: acc.id,
            userId: acc.userId,
            bankName: acc.bankName,
            accountNumber: acc.accountNumber,
            accountName: acc.accountName,
            isVerified: acc.isVerified,
            isActive: acc.isActive,
            isDefault: true,
            status: acc.status,
            createdAt: acc.createdAt,
            updatedAt: acc.updatedAt,
          );
        } else if (acc.isDefault) {
           return WithdrawalAccountModel(
            id: acc.id,
            userId: acc.userId,
            bankName: acc.bankName,
            accountNumber: acc.accountNumber,
            accountName: acc.accountName,
            isVerified: acc.isVerified,
            isActive: acc.isActive,
            isDefault: false,
            status: acc.status,
            createdAt: acc.createdAt,
            updatedAt: acc.updatedAt,
          );
        }
        return acc;
      }).toList();
      
      state = state.copyWith(isActionLoading: false, accounts: updatedAccounts);
      return true;
    } catch (e) {
      log('[WithdrawalAccountsNotifier] Error setting default account: $e');
      state = state.copyWith(isActionLoading: false, actionErrorMessage: e.toString());
      return false;
    }
  }
}
