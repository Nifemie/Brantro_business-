import '../../../orders/data/models/order_model.dart';

class AdCampaignModel {
  final int id;
  final int advertiserId;
  final String method;
  final String currency;
  final double amount;
  final String paymentRef;
  final String reference;
  final String status;
  final String remark;
  final bool settled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String advertiserName;
  final String advertiserEmail;
  final String advertiserPhone;
  final int placementsCount;
  final Map<String, dynamic> rawJson;

  AdCampaignModel({
    required this.id,
    required this.advertiserId,
    required this.method,
    required this.currency,
    required this.amount,
    required this.paymentRef,
    required this.reference,
    required this.status,
    required this.remark,
    required this.settled,
    required this.createdAt,
    required this.updatedAt,
    required this.advertiserName,
    required this.advertiserEmail,
    required this.advertiserPhone,
    required this.placementsCount,
    required this.rawJson,
  });

  factory AdCampaignModel.fromJson(Map<String, dynamic> json) {
    final advertiser = json['advertiser'] ?? {};
    final placements = json['placements'] as List? ?? [];
    
    // If there's a placement, prefer its amount and status (useful when filtering by adSlotId)
    double amount = double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0;
    String status = json['status'] ?? 'PENDING';
    
    if (placements.isNotEmpty) {
      final firstPlacement = placements.first;
      status = firstPlacement['status'] ?? status;
    }

    return AdCampaignModel(
      id: json['id'],
      advertiserId: json['advertiserId'] ?? 0,
      method: json['method'] ?? '',
      currency: json['currency'] ?? 'NGN',
      amount: amount,
      paymentRef: json['paymentRef'] ?? '',
      reference: json['reference'] ?? '',
      status: status,
      remark: json['remark'] ?? '',
      settled: json['settled'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      advertiserName: advertiser['name'] ?? 'Unknown',
      advertiserEmail: advertiser['emailAddress'] ?? '',
      advertiserPhone: advertiser['phoneNumber'] ?? '',
      placementsCount: placements.length,
      rawJson: json,
    );
  }

  OrderModel toOrderModel() {
    final placements = rawJson['placements'] as List? ?? [];
    final firstPlacement = placements.isNotEmpty ? placements.first : {};
    final adSlot = firstPlacement['adSlot'] ?? {};
    
    return OrderModel(
      id: reference,
      serviceType: 'ad_campaign',
      serviceName: adSlot['title']?.toString() ?? 'Ad Campaign Order',
      customerName: advertiserName,
      customerEmail: advertiserEmail,
      customerPhone: advertiserPhone,
      amount: amount,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: remark,
      imageUrl: null,
      itemsCount: placementsCount,
      metadata: rawJson,
    );
  }
}

