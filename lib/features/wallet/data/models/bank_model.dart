class BankModel {
  final int id;
  final String name;
  final String slug;
  final String? code;
  final String currency;
  final String country;
  final bool active;
  final String type;

  const BankModel({
    required this.id,
    required this.name,
    required this.slug,
    this.code,
    this.currency = 'NGN',
    this.country = 'Nigeria',
    this.active = true,
    this.type = 'nuban',
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      code: json['code']?.toString() ?? json['longcode']?.toString(),
      currency: json['currency']?.toString() ?? 'NGN',
      country: json['country']?.toString() ?? 'Nigeria',
      active: json['active'] == true,
      type: json['type']?.toString() ?? 'nuban',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      if (code != null) 'code': code,
      'currency': currency,
      'country': country,
      'active': active,
      'type': type,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class AccountResolutionResult {
  final String accountNumber;
  final String accountName;
  final int bankId;
  final String bankName;
  final bool verified;

  const AccountResolutionResult({
    required this.accountNumber,
    required this.accountName,
    required this.bankId,
    required this.bankName,
    required this.verified,
  });

  factory AccountResolutionResult.fromJson(Map<String, dynamic> json) {
    return AccountResolutionResult(
      accountNumber: json['accountNumber']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
      bankId: int.tryParse(json['bankId']?.toString() ?? '') ?? 0,
      bankName: json['bankName']?.toString() ?? '',
      verified: json['verified'] == true,
    );
  }
}
