import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/wallet_response.dart';
import 'models/transactions_response.dart';

class WalletRepository {
  final ApiClient apiClient;

  WalletRepository(this.apiClient);

  /// Get current user's wallet details
  Future<WalletResponse> getWallet() async {
    try {
      log('[WalletRepository] Fetching wallet details');

      final response = await apiClient.get(ApiEndpoints.walletMe);

      log('[WalletRepository] Wallet response received: ${response.statusCode}');
      final walletResponse = WalletResponse.fromJson(response.data);
      log('[WalletRepository] Wallet balance: ${walletResponse.payload.balance}');
      return walletResponse;
    } on DioException catch (e) {
      log('[WalletRepository] DioException: ${e.message}');
      log('[WalletRepository] Status Code: ${e.response?.statusCode}');
      log('[WalletRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have access to wallet'
              : e.response?.data['message'] ??
                  e.response?.data['error'] ??
                  'Failed to fetch wallet. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[WalletRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Refresh wallet balance (same as getWallet but semantically different)
  Future<WalletResponse> refreshWallet() async {
    return getWallet();
  }

  /// Get wallet transactions with pagination
  Future<TransactionsResponse> getTransactions({
    int page = 0,
    int size = 20,
  }) async {
    try {
      log('[WalletRepository] Fetching transactions: page=$page, size=$size');

      final response = await apiClient.get(
        ApiEndpoints.walletTransactions,
        query: {
          'page': page,
          'size': size,
        },
      );

      log('[WalletRepository] Transactions response received: ${response.statusCode}');
      final transactionsResponse = TransactionsResponse.fromJson(response.data);
      log('[WalletRepository] Fetched ${transactionsResponse.payload.transactions.length} transactions');
      return transactionsResponse;
    } on DioException catch (e) {
      log('[WalletRepository] DioException: ${e.message}');
      log('[WalletRepository] Status Code: ${e.response?.statusCode}');
      log('[WalletRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have access to transactions'
              : e.response?.data['message'] ??
                  e.response?.data['error'] ??
                  'Failed to fetch transactions. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[WalletRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
