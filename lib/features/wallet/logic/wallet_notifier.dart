import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/wallet_repository.dart';
import '../data/models/wallet_model.dart';

// Providers
final apiClientProvider = Provider((ref) => ApiClient());

final walletRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

// Wallet State
class WalletState {
  final bool isLoading;
  final bool isRefreshing;
  final WalletModel? wallet;
  final String? errorMessage;

  const WalletState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.wallet,
    this.errorMessage,
  });

  factory WalletState.initial() => const WalletState(
        isLoading: false,
        isRefreshing: false,
        wallet: null,
        errorMessage: null,
      );

  WalletState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    WalletModel? wallet,
    String? errorMessage,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage,
    );
  }
}

// Wallet Notifier
class WalletNotifier extends StateNotifier<WalletState> {
  final WalletRepository _repository;

  WalletNotifier(this._repository) : super(WalletState.initial());

  Future<void> fetchWallet() async {
    log('[WalletNotifier] Fetching wallet');

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final response = await _repository.getWallet();
      log('[WalletNotifier] Successfully fetched wallet: ${response.payload.balance}');

      state = state.copyWith(
        isLoading: false,
        wallet: response.payload,
        errorMessage: null,
      );
    } catch (e, stack) {
      log('[WalletNotifier] Error fetching wallet: $e\n$stack');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refreshWallet() async {
    log('[WalletNotifier] Refreshing wallet');

    state = state.copyWith(
      isRefreshing: true,
      errorMessage: null,
    );

    try {
      final response = await _repository.refreshWallet();
      log('[WalletNotifier] Successfully refreshed wallet: ${response.payload.balance}');

      state = state.copyWith(
        isRefreshing: false,
        wallet: response.payload,
        errorMessage: null,
      );
    } catch (e, stack) {
      log('[WalletNotifier] Error refreshing wallet: $e\n$stack');
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = WalletState.initial();
  }
}

// Provider
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>(
  (ref) {
    final repository = ref.watch(walletRepositoryProvider);
    return WalletNotifier(repository);
  },
);
