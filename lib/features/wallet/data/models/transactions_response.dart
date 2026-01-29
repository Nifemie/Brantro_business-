import 'transaction_model.dart';

class TransactionsResponse {
  final bool success;
  final String message;
  final TransactionsPayload payload;

  TransactionsResponse({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool;
    final message = json['message'] as String;
    final payloadData = json['payload'];
    
    // Handle null payload (e.g., "Record not found")
    if (payloadData == null) {
      return TransactionsResponse(
        success: success,
        message: message,
        payload: TransactionsPayload(
          transactions: [],
          currentPage: '0',
          size: '20',
          totalPages: 0,
        ),
      );
    }
    
    final payload = TransactionsPayload.fromJson(payloadData as Map<String, dynamic>);
    
    return TransactionsResponse(
      success: success,
      message: message,
      payload: payload,
    );
  }
}

class TransactionsPayload {
  final List<TransactionModel> transactions;
  final String currentPage;
  final String size;
  final int totalPages;

  TransactionsPayload({
    required this.transactions,
    required this.currentPage,
    required this.size,
    required this.totalPages,
  });

  factory TransactionsPayload.fromJson(Map<String, dynamic> json) {
    final pageList = json['page'] as List? ?? [];
    
    final transactions = pageList
        .where((e) => e != null && e is Map<String, dynamic>)
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    
    return TransactionsPayload(
      transactions: transactions,
      currentPage: json['currentPage']?.toString() ?? '0',
      size: json['size']?.toString() ?? '20',
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
