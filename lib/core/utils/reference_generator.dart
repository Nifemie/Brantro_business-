import 'dart:math';

class ReferenceGenerator {
  /// Generate a unique reference with a prefix
  /// Matches TypeScript: `${prefix ? prefix + "-" : ""}${Date.now()}`
  /// Example: generateReference('TPL') => 'TPL-1738012345678'
  /// Example: generateReference() => '1738012345678'
  static String generateReference([String prefix = '']) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    if (prefix.isEmpty) {
      return timestamp.toString().trim();
    }
    return '$prefix-$timestamp'.trim();
  }

  /// Generate a unique reference with prefix and random suffix
  /// Example: generateReferenceWithRandom('ORD') => 'ORD-1738012345678-A3F'
  static String generateReferenceWithRandom(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _generateRandomString(3);
    return '$prefix-$timestamp-$random';
  }

  /// Generate a short reference code
  /// Example: generateShortCode() => 'A3F9K2'
  static String generateShortCode([int length = 6]) {
    return _generateRandomString(length).toUpperCase();
  }

  /// Generate a numeric reference
  /// Example: generateNumericReference('INV') => 'INV-270127123456'
  static String generateNumericReference(String prefix) {
    final now = DateTime.now();
    final dateCode = '${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timeCode = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return '$prefix-$dateCode$timeCode';
  }

  /// Generate a payment reference for Paystack
  /// Example: generatePaymentReference('campaign') => 'PAY-CAMPAIGN-1738012345678-A3F'
  static String generatePaymentReference(String orderType) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _generateRandomString(4);
    return 'PAY-${orderType.toUpperCase()}-$timestamp-$random';
  }

  static String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
