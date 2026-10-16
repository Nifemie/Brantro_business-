/// Document types for individual accounts
const List<Map<String, String>> INDIVIDUAL_DOCUMENT_TYPES = [
  {'label': 'National Identity Number (NIN)', 'value': 'NIN'},
];

/// Document types for business accounts
const List<Map<String, String>> BUSINESS_DOCUMENT_TYPES = [
  {'label': 'Corporate Affairs Commission (CAC)', 'value': 'CAC'},
  {'label': 'National Identity Number (NIN)', 'value': 'NIN'},
];

enum KycVerificationStatus {
  notStarted,
  pending,
  inReview,
  approved,
  rejected,
}

extension KycVerificationStatusExtension on KycVerificationStatus {
  String get displayName {
    switch (this) {
      case KycVerificationStatus.notStarted:
        return 'Not Started';
      case KycVerificationStatus.pending:
        return 'Pending';
      case KycVerificationStatus.inReview:
        return 'In Review';
      case KycVerificationStatus.approved:
        return 'Approved';
      case KycVerificationStatus.rejected:
        return 'Rejected';
    }
  }

  String get description {
    switch (this) {
      case KycVerificationStatus.notStarted:
        return 'Complete your KYC verification to unlock all features';
      case KycVerificationStatus.pending:
        return 'Your verification is being processed';
      case KycVerificationStatus.inReview:
        return 'Our team is reviewing your documents';
      case KycVerificationStatus.approved:
        return 'Your account is verified';
      case KycVerificationStatus.rejected:
        return 'Verification failed. Please resubmit';
    }
  }
}

class KycValidationRules {
  /// NIN validation - exactly 11 digits
  static bool isValidNIN(String nin) {
    final clean = nin.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 11) return false;
    // Reject repeated placeholder digits like 00000000000
    if (RegExp(r'^(\d)\1{10}$').hasMatch(clean)) return false;
    return true;
  }

  /// CAC validation - Accepts RC/BN/IT followed by digits or 6-8 digit registration number
  static bool isValidCAC(String cac) {
    final clean = cac.trim();
    if (clean.length < 6 || clean.length > 14) return false;
    return RegExp(r'^(RC|BN|IT)?\s*\d{6,8}$', caseSensitive: false).hasMatch(clean) ||
        RegExp(r'^\d{6,8}$').hasMatch(clean);
  }

  /// Phone number validation - Nigerian format (10 or 11 digits)
  static bool isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length == 11) {
      return cleanPhone.startsWith('0');
    }
    if (cleanPhone.length == 10) {
      return !cleanPhone.startsWith('0');
    }
    if (cleanPhone.length == 13 && cleanPhone.startsWith('234')) {
      return true;
    }
    return false;
  }

  /// Get validation error message for document number
  static String? getDocumentNumberError(String documentType, String value) {
    final clean = value.trim();
    if (clean.isEmpty) {
      return '$documentType number is required';
    }

    switch (documentType.toUpperCase()) {
      case 'NIN':
        final digits = clean.replaceAll(RegExp(r'\D'), '');
        if (digits.length != 11) {
          return 'NIN must be exactly 11 digits (entered ${digits.length})';
        }
        if (!isValidNIN(clean)) {
          return 'Please enter a valid 11-digit NIN';
        }
        break;
      case 'CAC':
        if (!isValidCAC(clean)) {
          return 'Enter a valid CAC number (e.g. RC1234567 or 1234567)';
        }
        break;
      default:
        if (clean.length < 6) {
          return 'Enter a valid $documentType number';
        }
        break;
    }
    return null;
  }
}



const List<Map<String, String>> KYC_BENEFITS = [
  {
    'icon': '✓',
    'title': 'Unlock All Features',
    'description': 'Access premium features and higher transaction limits',
  },
  {
    'icon': '🔒',
    'title': 'Enhanced Security',
    'description': 'Protect your account with verified identity',
  },
  {
    'icon': '⚡',
    'title': 'Faster Transactions',
    'description': 'Enjoy priority processing and instant approvals',
  },
  {
    'icon': '🌟',
    'title': 'Build Trust',
    'description': 'Verified badge increases credibility with partners',
  },
];
