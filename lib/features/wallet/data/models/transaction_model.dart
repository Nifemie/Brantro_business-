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
  final String status;
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
    this.status = 'COMPLETED',
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: int.tryParse(json['id']?.toString() ?? json['_id']?.toString() ?? '0') ?? 0,
      walletId: int.tryParse(json['walletId']?.toString() ?? '0') ?? 0,
      type: json['type'] as String? ?? 'UNKNOWN',
      source: json['source'] as String? ?? 'UNKNOWN',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      balanceBefore: double.tryParse(json['balanceBefore']?.toString() ?? '0') ?? 0.0,
      balanceAfter: double.tryParse(json['balanceAfter']?.toString() ?? '0') ?? 0.0,
      reference: json['reference'] as String? ?? '',
      narration: json['narration'] as String?,
      status: json['status']?.toString().toUpperCase() ?? 'COMPLETED',
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
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
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isCredit {
    final t = type.toUpperCase();
    final s = source.toUpperCase();
    return t == 'CREDIT' ||
        t == 'DEPOSIT' ||
        t == 'UPDATE' ||
        t == 'REFUND' ||
        t == 'TRANSFER_IN' ||
        s == 'FUNDING';
  }

  bool get isDebit {
    final t = type.toUpperCase();
    return t == 'DEBIT' ||
        t == 'WITHDRAWAL' ||
        t == 'TRANSFER_OUT' ||
        t == 'PAYMENT';
  }
  
  // For UI display
  String get description => narration ?? source;
  
  // For backward compatibility
  bool get isCompleted => status == 'COMPLETED' || status == 'SUCCESS';
  bool get isPending => status == 'PENDING';
  bool get isFailed => status == 'FAILED';
}
