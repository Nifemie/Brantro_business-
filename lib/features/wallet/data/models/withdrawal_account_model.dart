class WithdrawalAccountModel {
  final int? id;
  final int? userId;
  final int? bankId;
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
    this.bankId,
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

    final parsedId = int.tryParse(json['id']?.toString() ??
        json['_id']?.toString() ??
        json['accountId']?.toString() ??
        json['withdrawalAccountId']?.toString() ??
        '');
    final parsedUserId = int.tryParse(json['userId']?.toString() ?? '');
    final parsedBankId = int.tryParse(json['bankId']?.toString() ?? '');

    final isActiveVal = json['isActive'] != false &&
        json['isDeleted'] != true &&
        statusStr != 'DELETED' &&
        statusStr != 'INACTIVE';

    return WithdrawalAccountModel(
      id: parsedId,
      userId: parsedUserId,
      bankId: parsedBankId,
      bankName: json['bankName']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
      isVerified: isVerifiedVal,
      isActive: isActiveVal,
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

  /// Output JSON for creation/updating adhering to Brantro Mobile API Handoff specification:
  /// Submit only bankId, accountNumber, and isDefault.
  Map<String, dynamic> toJson() {
    if (bankId != null) {
      return {
        'bankId': bankId,
        'accountNumber': accountNumber,
        'isDefault': isDefault,
      };
    }
    final map = <String, dynamic>{
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'isDefault': isDefault,
    };
    if (status != null) map['status'] = status;
    return map;
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
