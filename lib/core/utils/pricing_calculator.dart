/// Pricing calculator utility for calculating VAT, service charges, and totals
class PricingCalculator {
  // Charge rates (matching environment variables)
  static const double VAT_RATE = 0.075; // 7.5%
  static const double SERVICE_CHARGE_RATE = 0.05; // 5%

  /// Calculate VAT from subtotal
  static double calculateVAT(double subtotal) {
    return subtotal * VAT_RATE;
  }

  /// Calculate service charge from subtotal
  static double calculateServiceCharge(double subtotal) {
    return subtotal * SERVICE_CHARGE_RATE;
  }

  /// Calculate total including VAT and service charge
  static double calculateTotal(double subtotal) {
    final vat = calculateVAT(subtotal);
    final serviceCharge = calculateServiceCharge(subtotal);
    return subtotal + vat + serviceCharge;
  }

  /// Get pricing breakdown
  static PricingBreakdown getBreakdown(double subtotal) {
    final vat = calculateVAT(subtotal);
    final serviceCharge = calculateServiceCharge(subtotal);
    final total = subtotal + vat + serviceCharge;

    return PricingBreakdown(
      subtotal: subtotal,
      vat: vat,
      serviceCharge: serviceCharge,
      total: total,
    );
  }

  /// Check if wallet balance is sufficient
  static bool isWalletSufficient(double walletBalance, double total) {
    return walletBalance >= total;
  }

  /// Format amount to currency string
  static String formatAmount(double amount) {
    if (amount >= 1000000) {
      return '₦${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '₦${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₦${amount.toStringAsFixed(2)}';
  }

  /// Format amount with full precision
  static String formatAmountFull(double amount) {
    return '₦${amount.toStringAsFixed(2)}';
  }
}

/// Pricing breakdown model
class PricingBreakdown {
  final double subtotal;
  final double vat;
  final double serviceCharge;
  final double total;

  PricingBreakdown({
    required this.subtotal,
    required this.vat,
    required this.serviceCharge,
    required this.total,
  });

  /// Get formatted strings for display
  String get formattedSubtotal => PricingCalculator.formatAmountFull(subtotal);
  String get formattedVAT => PricingCalculator.formatAmountFull(vat);
  String get formattedServiceCharge => PricingCalculator.formatAmountFull(serviceCharge);
  String get formattedTotal => PricingCalculator.formatAmountFull(total);

  /// Get VAT percentage as string
  String get vatPercentage => '${(PricingCalculator.VAT_RATE * 100).toStringAsFixed(1)}%';
  
  /// Get service charge percentage as string
  String get serviceChargePercentage => '${(PricingCalculator.SERVICE_CHARGE_RATE * 100).toStringAsFixed(1)}%';

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'vat': vat,
      'serviceCharge': serviceCharge,
      'total': total,
    };
  }
}
