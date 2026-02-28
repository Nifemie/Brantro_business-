class TransactionModel {
  final int id;
  final int walletId;
  final String type;
  final String source;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String reference;
  final String? narration;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.source,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.reference,
    this.narration,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int? ?? 0,
      walletId: json['walletId'] as int? ?? 0,
      type: json['type'] as String? ?? 'UNKNOWN',
      source: json['source'] as String? ?? 'UNKNOWN',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      balanceBefore: double.tryParse(json['balanceBefore']?.toString() ?? '0') ?? 0.0,
      balanceAfter: double.tryParse(json['balanceAfter']?.toString() ?? '0') ?? 0.0,
      reference: json['reference'] as String? ?? '',
      narration: json['narration'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'type': type,
      'source': source,
      'amount': amount,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      'reference': reference,
      'narration': narration,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isCredit => type == 'CREDIT' || type == 'UPDATE' || source == 'FUNDING';
  bool get isDebit => type == 'DEBIT';
  
  // For UI display
  String get description => narration ?? source;
  String get status => 'COMPLETED'; // All transactions in history are completed
  
  // For backward compatibility
  bool get isCompleted => true;
  bool get isPending => false;
  bool get isFailed => false;
}
