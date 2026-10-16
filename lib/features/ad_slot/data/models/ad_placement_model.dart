class AdPlacementModel {
  final int id;
  final int campaignId;
  final int adSlotId;
  final double amount;
  final String status;
  final String description;
  final DateTime createdAt;
  
  final String advertiserName;
  final String advertiserEmail;
  
  final List<String> platforms;
  final List<String> contentTypes;
  final bool hasApprovedProof;

  final Map<String, dynamic> rawJson;

  AdPlacementModel({
    required this.id,
    required this.campaignId,
    required this.adSlotId,
    required this.amount,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.advertiserName,
    required this.advertiserEmail,
    required this.platforms,
    required this.contentTypes,
    required this.hasApprovedProof,
    required this.rawJson,
  });

  factory AdPlacementModel.fromJson(Map<String, dynamic> json) {
    final advertiser = json['advertiser'] ?? {};
    final adSlot = json['adSlot'] ?? {};

    final platformsList = (adSlot['platforms'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final contentTypesList = (adSlot['contentTypes'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return AdPlacementModel(
      id: json['id'] ?? 0,
      campaignId: json['campaignId'] ?? 0,
      adSlotId: json['adSlotId'] ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'REQUESTED',
      description: json['description'] ?? 'Campaign order',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      advertiserName: advertiser['name'] ?? 'Unknown',
      advertiserEmail: advertiser['emailAddress'] ?? '',
      platforms: platformsList,
      contentTypes: contentTypesList,
      hasApprovedProof: json['hasApprovedProof'] ?? false,
      rawJson: json,
    );
  }
}
