class ServiceOrderRequest {
  final List<ServiceOrderItem> items;
  final String method;
  final String currency;
  final double amount;
  final String paymentRef;
  final String remark;

  ServiceOrderRequest({
    required this.items,
    required this.method,
    required this.currency,
    required this.amount,
    required this.paymentRef,
    required this.remark,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'method': method,
      'currency': currency,
      'amount': amount,
      'paymentRef': paymentRef,
      'remark': remark,
    };
  }
}

class ServiceOrderItem {
  final int id;
  final String reference;
  final ServiceRequirements requirements;

  ServiceOrderItem({
    required this.id,
    required this.reference,
    required this.requirements,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'requirements': requirements.toJson(),
    };
  }
}

class ServiceRequirements {
  final String? description;
  final List<String>? links;
  final List<ServiceFile>? files;

  ServiceRequirements({
    this.description,
    this.links,
    this.files,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    
    if (description != null && description!.isNotEmpty) {
      json['description'] = description;
    }
    
    if (links != null && links!.isNotEmpty) {
      json['links'] = links;
    }
    
    if (files != null && files!.isNotEmpty) {
      json['files'] = files!.map((f) => f.toJson()).toList();
    }
    
    return json;
  }
}

class ServiceFile {
  final String id;
  final String name;
  final String mimeType;
  final int size;

  ServiceFile({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mimeType': mimeType,
      'size': size,
    };
  }
}
