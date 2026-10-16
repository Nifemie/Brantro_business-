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
    final rawCurrency = json['currency']?.toString() ?? '₦';
    final currencySymbol = (rawCurrency.trim() == 'NGN') ? '₦' : rawCurrency;

    return WalletModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      balance: json['balance']?.toString() ?? '0.00',
      pendingBalance: json['pendingBalance']?.toString() ?? '0.00',
      status: json['status']?.toString() ?? 'ACTIVE',
      currency: currencySymbol,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
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
  String get currencySymbol => (currency.trim() == 'NGN') ? '₦' : currency;
}
