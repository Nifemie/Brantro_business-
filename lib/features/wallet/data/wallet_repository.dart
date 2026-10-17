import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/wallet_response.dart';
import 'models/transactions_response.dart';
import 'models/withdrawal_account_model.dart';

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

  // --- Withdrawal Accounts ---

  Future<List<WithdrawalAccountModel>> getWithdrawalAccounts() async {
    try {
      log('[WalletRepository] Fetching withdrawal accounts');
      final response = await apiClient.get(ApiEndpoints.withdrawalAccountList);
      
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        // Assume payload is a list or contains a list
        List<dynamic> data = [];
        if (payload is List) {
          data = payload;
        } else if (payload != null && payload['page'] is List) {
          data = payload['page'];
        }
        return data.map((json) => WithdrawalAccountModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      log('[WalletRepository] Failed to fetch withdrawal accounts: ${e.message}');
      throw Exception(e.response?.data?['message'] ?? 'Failed to load withdrawal accounts.');
    }
  }

  Future<WithdrawalAccountModel> addWithdrawalAccount(WithdrawalAccountModel account) async {
    try {
      log('[WalletRepository] Adding withdrawal account');
      final response = await apiClient.post(
        ApiEndpoints.withdrawalAccount,
        data: account.toJson(),
      );
      
      final isSuccess = response.data != null &&
          (response.data['success'] == true ||
           response.statusCode == 200 ||
           response.statusCode == 201);

      if (isSuccess) {
        final payload = response.data['payload'] ??
            response.data['data'] ??
            response.data['account'];

        if (payload != null && payload is Map<String, dynamic>) {
          return WithdrawalAccountModel.fromJson(payload);
        }
        return account;
      }
      final msg = response.data?['message'] ?? 'Failed to add account. Invalid response.';
      throw Exception(msg);
    } on DioException catch (e) {
      log('[WalletRepository] Failed to add withdrawal account: ${e.message}');
      final msg = e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          'Failed to add withdrawal account. Please check your bank details.';
      throw Exception(msg);
    }
  }

  Future<void> deleteWithdrawalAccount(int id) async {
    try {
      log('[WalletRepository] Deleting withdrawal account $id');
      final response = await apiClient.delete(
        ApiEndpoints.deleteWithdrawalAccount(id),
      );
      if (response.data == null || response.data['success'] != true) {
         throw Exception('Failed to delete account.');
      }
    } on DioException catch (e) {
      log('[WalletRepository] Failed to delete withdrawal account: ${e.message}');
      throw Exception(e.response?.data?['message'] ?? 'Failed to delete withdrawal account.');
    }
  }

  Future<void> makeDefaultWithdrawalAccount(int id) async {
    try {
      log('[WalletRepository] Setting default withdrawal account $id');
      final response = await apiClient.patch(
        ApiEndpoints.defaultWithdrawalAccount(id),
      );
      if (response.data == null || response.data['success'] != true) {
         throw Exception('Failed to set default account.');
      }
    } on DioException catch (e) {
      log('[WalletRepository] Failed to set default account: ${e.message}');
      throw Exception(e.response?.data?['message'] ?? 'Failed to set default account.');
    }
  }

  Future<void> requestWithdrawal({
    required double amount,
    required int accountId,
    required String narration,
  }) async {
    try {
      log('[WalletRepository] Requesting withdrawal of $amount to account $accountId');
      final response = await apiClient.post(
        ApiEndpoints.withdrawalRequest,
        data: {
          "amount": amount,
          "withdrawalAccountId": accountId,
          "narration": narration,
        },
      );
      
      if (response.data == null || response.data['success'] != true) {
         throw Exception(response.data?['message'] ?? 'Failed to request withdrawal.');
      }
    } on DioException catch (e) {
      log('[WalletRepository] Failed to request withdrawal: ${e.message}');
      throw Exception(e.response?.data?['message'] ?? 'Failed to request withdrawal.');
    }
  }
}

