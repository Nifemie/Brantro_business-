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

      String errorMessage = 'Failed to fetch transactions. Please try again.';
      if (e.response?.statusCode == 401) {
        errorMessage = 'Unauthorized: Please log in again';
      } else if (e.response?.statusCode == 403) {
        errorMessage = 'Forbidden: You do not have access to transactions';
      } else if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ??
            e.response?.data['error'] ??
            errorMessage;
      }

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
      
      if (response.data != null) {
        dynamic payload = response.data;
        if (response.data is Map) {
          payload = response.data['payload'] ??
              response.data['data'] ??
              response.data['accounts'] ??
              (response.data['success'] == true ? response.data : null);
        }
        List<dynamic> data = [];
        if (payload is List) {
          data = payload;
        } else if (payload is Map && payload['page'] is List) {
          data = payload['page'];
        } else if (payload is Map && payload['accounts'] is List) {
          data = payload['accounts'];
        }
        final accounts = data
            .whereType<Map<String, dynamic>>()
            .map((json) => WithdrawalAccountModel.fromJson(json))
            .where((acc) => acc.isActive && acc.status != 'DELETED')
            .toList();
        return accounts;
      }
      return [];
    } on DioException catch (e) {
      log('[WalletRepository] Failed to fetch withdrawal accounts: ${e.message}');
      String msg = 'Failed to load withdrawal accounts.';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
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
          ((response.data is Map && response.data['success'] == true) ||
           response.statusCode == 200 ||
           response.statusCode == 201);

      if (isSuccess && response.data is Map) {
        final payload = response.data['payload'] ??
            response.data['data'] ??
            response.data['account'];

        if (payload != null && payload is Map<String, dynamic>) {
          return WithdrawalAccountModel.fromJson(payload);
        }
        return account;
      }
      final msg = response.data is Map
          ? (response.data['message'] ?? 'Failed to add account. Invalid response.')
          : 'Failed to add account. Invalid response.';
      throw Exception(msg);
    } on DioException catch (e) {
      log('[WalletRepository] Failed to add withdrawal account: ${e.message}');
      String msg = 'Failed to add withdrawal account. Please check your bank details.';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
    }
  }

  Future<void> deleteWithdrawalAccount(int id) async {
    try {
      log('[WalletRepository] Deleting withdrawal account $id');
      final response = await apiClient.delete(
        ApiEndpoints.deleteWithdrawalAccount(id),
      );
      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 204 ||
          (response.data is Map &&
              (response.data['success'] == true ||
                  response.data['status'] == 'success' ||
                  response.data['message'] != null));
      if (!isSuccess) {
         throw Exception('Failed to delete account.');
      }
    } on DioException catch (e) {
      log('[WalletRepository] Failed to delete withdrawal account: ${e.message}');
      String msg = 'Failed to delete withdrawal account.';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
    }
  }

  Future<void> makeDefaultWithdrawalAccount(int id) async {
    try {
      log('[WalletRepository] Setting default withdrawal account $id');
      final response = await apiClient.patch(
        ApiEndpoints.defaultWithdrawalAccount(id),
      );
      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 204 ||
          (response.data is Map &&
              (response.data['success'] == true ||
               response.data['status'] == 'success'));
      if (!isSuccess) {
         final msg = response.data is Map ? (response.data['message'] ?? 'Failed to set default account.') : 'Failed to set default account.';
         throw Exception(msg);
      }
    } on DioException catch (e) {
      log('[WalletRepository] Failed to set default account: ${e.message}');
      String msg = 'Failed to set default account.';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
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
      
      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 201 ||
          (response.data is Map &&
              (response.data['success'] == true ||
               response.data['status'] == 'success'));

      if (!isSuccess) {
         final msg = response.data is Map ? (response.data['message'] ?? 'Failed to request withdrawal.') : 'Failed to request withdrawal.';
         throw Exception(msg);
      }
    } on DioException catch (e) {
      log('[WalletRepository] Failed to request withdrawal: ${e.message}');
      String msg = 'Failed to request withdrawal.';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
    }
  }
}

