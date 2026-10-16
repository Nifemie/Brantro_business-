class WithdrawalAccountModel {
  final int? id;
  final int? userId;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final bool isVerified;
  final bool isActive;
  final bool isDefault;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WithdrawalAccountModel({
    this.id,
    this.userId,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    this.isVerified = false,
    this.isActive = true,
    this.isDefault = false,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawalAccountModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status']?.toString().toUpperCase();
    final isVerifiedVal = json['isVerified'] == true ||
        statusStr == 'VERIFIED' ||
        json['verificationStatus']?.toString().toUpperCase() == 'VERIFIED';

    return WithdrawalAccountModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      bankName: json['bankName']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
      isVerified: isVerifiedVal,
      isActive: json['isActive'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      status: statusStr ?? (isVerifiedVal ? 'VERIFIED' : 'PENDING'),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'isDefault': isDefault,
      if (status != null) 'status': status,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithdrawalAccountModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          accountNumber == other.accountNumber;

  @override
  int get hashCode => id.hashCode ^ accountNumber.hashCode;
}
