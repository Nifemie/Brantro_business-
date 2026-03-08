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

      log(
        '[WalletRepository] Wallet response received: ${response.statusCode}',
      );
      final walletResponse = WalletResponse.fromJson(response.data);
      log(
        '[WalletRepository] Wallet balance: ${walletResponse.payload.balance}',
      );
      return walletResponse;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      final fullUrl = '${e.requestOptions.baseUrl}${e.requestOptions.path}';

      log('[WalletRepository] Fetch FAILED');
      log('[WalletRepository] URL: $fullUrl');
      log('[WalletRepository] Status Code: $statusCode');
      log('[WalletRepository] Error Data: $responseData');
      log('[WalletRepository] Message: ${e.message}');

      String errorMessage = 'Failed to fetch wallet. Please try again.';

      if (statusCode == 404) {
        errorMessage =
            'Wallet service not found (404). Please contact support.';
      } else if (statusCode == 401) {
        errorMessage = 'Unauthorized: Please log in again';
      } else if (statusCode == 403) {
        errorMessage = 'Forbidden: You do not have access to wallet';
      } else if (statusCode != null && statusCode >= 500) {
        errorMessage = 'Server error ($statusCode). Please try again later.';
      } else if (responseData is Map) {
        errorMessage =
            responseData['message'] ?? responseData['error'] ?? errorMessage;
      }

      throw Exception(errorMessage);
    } catch (e) {
      log('[WalletRepository] Unexpected Error: $e');
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
        query: {'page': page, 'size': size},
      );

      log(
        '[WalletRepository] Transactions response received: ${response.statusCode}',
      );
      final transactionsResponse = TransactionsResponse.fromJson(response.data);
      log(
        '[WalletRepository] Fetched ${transactionsResponse.payload.transactions.length} transactions',
      );
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
