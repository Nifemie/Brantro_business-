class TemplateOrderRequest {
  final List<TemplateOrderItem> items;
  final String method;
  final String currency;
  final double amount;
  final String paymentRef;
  final String remark;

  TemplateOrderRequest({
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

class TemplateOrderItem {
  final int id;
  final String reference;

  TemplateOrderItem({
    required this.id,
    required this.reference,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
    };
  }
}
