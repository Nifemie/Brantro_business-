class CampaignOrderRequest {
  final String reference;
  final List<CampaignOrderItem> items;
  final String method;
  final String currency;
  final double amount;
  final String paymentRef;
  final String remark;

  CampaignOrderRequest({
    required this.reference,
    required this.items,
    required this.method,
    required this.currency,
    required this.amount,
    required this.paymentRef,
    required this.remark,
  });

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'items': items.map((item) => item.toJson()).toList(),
      'method': method,
      'currency': currency,
      'amount': amount,
      'paymentRef': paymentRef,
      'remark': remark,
    };
  }
}

class CampaignOrderItem {
  final String id;
  final int adSlotId;
  final int quantity;
  final List<CampaignCreative> creatives;

  CampaignOrderItem({
    required this.id,
    required this.adSlotId,
    required this.quantity,
    required this.creatives,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adSlotId': adSlotId,
      'quantity': quantity,
      'creatives': creatives.map((c) => c.toJson()).toList(),
    };
  }
}

class CampaignCreative {
  final String id;
  final String name;
  final String mimeType;
  final int size;
  final String? description;
  final String status;

  CampaignCreative({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.size,
    this.description,
    this.status = 'PENDING',
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'name': name,
      'mimeType': mimeType,
      'size': size,
      'status': status,
    };
    
    if (description != null && description!.isNotEmpty) {
      json['description'] = description;
    }
    
    return json;
  }
}
