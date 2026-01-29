/// Document types for individual accounts
const List<Map<String, String>> INDIVIDUAL_DOCUMENT_TYPES = [
  {'label': 'National Identity Number (NIN)', 'value': 'NIN'},
  {'label': 'Driver\'s License', 'value': 'DRIVERS_LICENSE'},
  {'label': 'International Passport', 'value': 'PASSPORT'},
  {'label': 'Voter\'s Card', 'value': 'VOTERS_CARD'},
];

/// Document types for business accounts
const List<Map<String, String>> BUSINESS_DOCUMENT_TYPES = [
  {'label': 'CAC Registration', 'value': 'CAC'},
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
  /// NIN validation - 11 digits
  static bool isValidNIN(String nin) {
    return RegExp(r'^\d{11}$').hasMatch(nin);
  }

  /// CAC validation - Starts with RC followed by digits
  static bool isValidCAC(String cac) {
    return RegExp(r'^RC\d{6,}$', caseSensitive: false).hasMatch(cac);
  }

  /// Driver's License validation - Alphanumeric
  static bool isValidDriversLicense(String license) {
    return RegExp(r'^[A-Z0-9]{6,}$', caseSensitive: false).hasMatch(license);
  }

  /// Passport validation - Alphanumeric
  static bool isValidPassport(String passport) {
    return RegExp(r'^[A-Z0-9]{6,}$', caseSensitive: false).hasMatch(passport);
  }

  /// Voter's Card validation - Alphanumeric
  static bool isValidVotersCard(String votersCard) {
    return RegExp(r'^[A-Z0-9]{6,}$', caseSensitive: false).hasMatch(votersCard);
  }

  /// Phone number validation - Nigerian format
  static bool isValidPhoneNumber(String phone) {
    // Remove spaces and special characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    // Should be 11 digits starting with 0, or 10 digits without 0
    return RegExp(r'^0\d{10}$').hasMatch(cleanPhone) ||
        RegExp(r'^\d{10}$').hasMatch(cleanPhone);
  }

  /// Get validation error message for document number
  static String? getDocumentNumberError(String documentType, String value) {
    if (value.isEmpty) {
      return 'Document number is required';
    }

    switch (documentType) {
      case 'NIN':
        if (!isValidNIN(value)) {
          return 'NIN must be exactly 11 digits';
        }
        break;
      case 'CAC':
        if (!isValidCAC(value)) {
          return 'CAC number must start with RC followed by at least 6 digits';
        }
        break;
      case 'DRIVERS_LICENSE':
        if (!isValidDriversLicense(value)) {
          return 'Invalid driver\'s license format';
        }
        break;
      case 'PASSPORT':
        if (!isValidPassport(value)) {
          return 'Invalid passport number format';
        }
        break;
      case 'VOTERS_CARD':
        if (!isValidVotersCard(value)) {
          return 'Invalid voter\'s card number format';
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
