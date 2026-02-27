class WalletModel {
  final int id;
  final int userId;
  final String balance;
  final String pendingBalance;
  final String status;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.pendingBalance,
    required this.status,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      balance: json['balance'] as String,
      pendingBalance: json['pendingBalance'] as String,
      status: json['status'] as String,
      currency: json['currency'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'pendingBalance': pendingBalance,
      'status': status,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper getters
  double get balanceAmount => double.tryParse(balance) ?? 0.0;
  double get pendingBalanceAmount => double.tryParse(pendingBalance) ?? 0.0;
  double get totalBalance => balanceAmount + pendingBalanceAmount;
  bool get isActive => status == 'ACTIVE';
}
