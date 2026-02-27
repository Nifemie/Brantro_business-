import '../data/models/payment_request.dart';
import '../../../core/constants/paystack_config.dart';
import '../../../core/utils/reference_generator.dart';

/// Helper class for creating payment requests for different purposes
class PaymentHelper {
  /// Create payment request for campaign payment
  static PaymentRequest createCampaignPayment({
    required String email,
    required int userId,
    required double totalAmount,
    required int campaignId,
    String? campaignName,
  }) {
    final reference = ReferenceGenerator.generatePaymentReference('campaign');
    
    return PaymentRequest.create(
      email: email,
      userId: userId,
      purpose: PaymentPurpose.campaignPayment,
      totalAmount: totalAmount,
      reference: reference,
      additionalData: {
        'campaignId': campaignId,
        if (campaignName != null) 'campaignName': campaignName,
      },
    );
  }

  /// Create payment request for creative purchase
  static PaymentRequest createCreativePurchase({
    required String email,
    required int userId,
    required double totalAmount,
    required int creativeId,
    String? creativeName,
  }) {
    final reference = ReferenceGenerator.generatePaymentReference('creative');
    
    return PaymentRequest.create(
      email: email,
      userId: userId,
      purpose: PaymentPurpose.creativePurchase,
      totalAmount: totalAmount,
      reference: reference,
      additionalData: {
        'creativeId': creativeId,
        if (creativeName != null) 'creativeName': creativeName,
      },
    );
  }

  /// Create payment request for service order
  static PaymentRequest createServiceOrderPayment({
    required String email,
    required int userId,
    required double totalAmount,
    required int serviceId,
    String? serviceName,
    int? orderId,
  }) {
    final reference = ReferenceGenerator.generatePaymentReference('service');
    
    return PaymentRequest.create(
      email: email,
      userId: userId,
      purpose: PaymentPurpose.serviceOrderPayment,
      totalAmount: totalAmount,
      reference: reference,
      additionalData: {
        'serviceId': serviceId,
        if (serviceName != null) 'serviceName': serviceName,
        if (orderId != null) 'orderId': orderId,
      },
    );
  }

  /// Create payment request for template purchase
  static PaymentRequest createTemplatePurchase({
    required String email,
    required int userId,
    required double totalAmount,
    required int templateId,
    String? templateName,
  }) {
    final reference = ReferenceGenerator.generatePaymentReference('template');
    
    return PaymentRequest.create(
      email: email,
      userId: userId,
      purpose: PaymentPurpose.templatePurchase,
      totalAmount: totalAmount,
      reference: reference,
      additionalData: {
        'templateId': templateId,
        if (templateName != null) 'templateName': templateName,
      },
    );
  }

  /// Create payment request for ad slot booking
  static PaymentRequest createAdSlotBooking({
    required String email,
    required int userId,
    required double totalAmount,
    required int adSlotId,
    String? adSlotName,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final reference = ReferenceGenerator.generatePaymentReference('adslot');
    
    return PaymentRequest.create(
      email: email,
      userId: userId,
      purpose: PaymentPurpose.adSlotBooking,
      totalAmount: totalAmount,
      reference: reference,
      additionalData: {
        'adSlotId': adSlotId,
        if (adSlotName != null) 'adSlotName': adSlotName,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      },
    );
  }

  /// Create payment request for wallet top-up
  static PaymentRequest createWalletTopup({
    required String email,
    required int userId,
    required double amount,
  }) {
    final reference = ReferenceGenerator.generatePaymentReference('wallet');
    
    return PaymentRequest.create(
      email: email,
      userId: userId,
      purpose: PaymentPurpose.walletTopup,
      totalAmount: amount,
      reference: reference,
    );
  }

  /// Create generic payment request with custom metadata
  static PaymentRequest createCustomPayment({
    required String email,
    required int userId,
    required String purpose,
    required double totalAmount,
    required String referencePrefix,
    Map<String, dynamic>? additionalData,
  }) {
    final reference = ReferenceGenerator.generatePaymentReference(referencePrefix);
    
    return PaymentRequest.create(
      email: email,
      userId: userId,
      purpose: purpose,
      totalAmount: totalAmount,
      reference: reference,
      additionalData: additionalData,
    );
  }
}
