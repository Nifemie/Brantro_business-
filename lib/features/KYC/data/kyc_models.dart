
class KycVerificationRequest {
  final String documentType;
  final String documentNumber;
  final String fullName;
  final String phoneNumber;
  final String address;

  KycVerificationRequest({
    required this.documentType,
    required this.documentNumber,
    required this.fullName,
    required this.phoneNumber,
    this.address = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'documentType': documentType,
      'documentNumber': documentNumber,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      if (address.isNotEmpty) 'address': address,
    };
  }

  factory KycVerificationRequest.fromJson(Map<String, dynamic> json) {
    return KycVerificationRequest(
      documentType: json['documentType']?.toString() ?? 'NIN',
      documentNumber: json['documentNumber']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }

  KycVerificationRequest copyWith({
    String? documentType,
    String? documentNumber,
    String? fullName,
    String? phoneNumber,
    String? address,
  }) {
    return KycVerificationRequest(
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }
}

class KycInitiateResponse {
  final String status; // 'COMPLETED', 'APPROVED', 'FACE_REQUIRED', 'OTP_REQUIRED', 'PENDING', 'IN_REVIEW'
  final String? message;
  final String? documentNumber;
  final bool isVerified;
  final Map<String, dynamic>? data;

  KycInitiateResponse({
    required this.status,
    this.message,
    this.documentNumber,
    this.isVerified = false,
    this.data,
  });

  factory KycInitiateResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] is Map<String, dynamic>
        ? json['payload'] as Map<String, dynamic>
        : (json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json);

    final rawStatus = payload['status']?.toString() ?? json['status']?.toString() ?? 'PENDING';
    final normalizedStatus = rawStatus.toUpperCase();
    final isDone = normalizedStatus == 'COMPLETED' || normalizedStatus == 'APPROVED';

    return KycInitiateResponse(
      status: normalizedStatus,
      message: payload['message']?.toString() ?? json['message']?.toString(),
      documentNumber: payload['documentNumber']?.toString() ?? json['documentNumber']?.toString(),
      isVerified: isDone || (payload['isVerified'] == true) || (json['isVerified'] == true),
      data: payload,
    );
  }
}

class KycStatusResponse {
  final String status; // 'PENDING', 'APPROVED', 'VERIFIED', 'FACE_REQUIRED', 'IN_REVIEW', 'REJECTED', 'NOT_STARTED'
  final String? message;
  final String? rejectionReason;
  final String? documentNumber;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final KycVerificationRequest? submittedData;

  KycStatusResponse({
    required this.status,
    this.message,
    this.rejectionReason,
    this.documentNumber,
    this.submittedAt,
    this.reviewedAt,
    this.submittedData,
  });

  factory KycStatusResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] is Map<String, dynamic>
        ? json['payload'] as Map<String, dynamic>
        : (json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json);

    final rawStatus = payload['status']?.toString() ??
        payload['kycStatus']?.toString() ??
        payload['verificationStatus']?.toString() ??
        payload['state']?.toString() ??
        json['status']?.toString() ??
        'NOT_STARTED';

    final rejection = payload['rejectionReason']?.toString() ??
        payload['reason']?.toString() ??
        payload['adminFeedback']?.toString() ??
        payload['rejection_reason']?.toString() ??
        json['rejectionReason']?.toString();

    final docNumber = payload['documentNumber']?.toString() ??
        payload['userProvidedData']?['documentNumber']?.toString() ??
        payload['providerResponse']?['data']?['nin']?.toString() ??
        json['documentNumber']?.toString();

    DateTime? parseDate(dynamic d) {
      if (d == null) return null;
      try {
        return DateTime.parse(d.toString());
      } catch (_) {
        return null;
      }
    }

    final submittedAt = parseDate(
      payload['submittedAt'] ??
          payload['createdAt'] ??
          payload['created_at'] ??
          json['submittedAt'] ??
          json['createdAt'],
    );
    final reviewedAt = parseDate(
      payload['reviewedAt'] ??
          payload['updatedAt'] ??
          payload['updated_at'] ??
          json['reviewedAt'] ??
          json['updatedAt'],
    );

    KycVerificationRequest? submittedData;
    final userData = payload['userProvidedData'] ?? payload['submittedData'];
    if (userData is Map<String, dynamic>) {
      submittedData = KycVerificationRequest.fromJson(
        Map<String, dynamic>.from(userData),
      );
    } else if (payload['documentNumber'] != null ||
        payload['documentType'] != null ||
        payload['fullName'] != null) {
      submittedData = KycVerificationRequest(
        documentType: payload['documentType']?.toString() ?? 'NIN',
        documentNumber: payload['documentNumber']?.toString() ?? '',
        fullName: payload['fullName']?.toString() ?? payload['name']?.toString() ?? '',
        phoneNumber: payload['phoneNumber']?.toString() ?? payload['phone']?.toString() ?? '',
        address: payload['address']?.toString() ?? '',
      );
    }

    final responseMessage = payload['providerResponse']?['message']?.toString() ??
        payload['message']?.toString() ??
        payload['reason']?.toString() ??
        json['message']?.toString();

    return KycStatusResponse(
      status: rawStatus.toUpperCase(),
      message: responseMessage,
      rejectionReason: rejection,
      documentNumber: docNumber,
      submittedAt: submittedAt,
      reviewedAt: reviewedAt,
      submittedData: submittedData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'documentNumber': documentNumber,
      'submittedAt': submittedAt?.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'submittedData': submittedData?.toJson(),
    };
  }
}

class KycOtpVerificationRequest {
  final String documentNumber;
  final String otp;

  KycOtpVerificationRequest({
    required this.documentNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentNumber': documentNumber,
      'otp': otp,
    };
  }

  factory KycOtpVerificationRequest.fromJson(Map<String, dynamic> json) {
    return KycOtpVerificationRequest(
      documentNumber: json['documentNumber'] as String,
      otp: json['otp'] as String,
    );
  }
}

class FaceVerificationRequest {
  final String documentNumber;
  final String imageBase64;

  FaceVerificationRequest({
    required this.documentNumber,
    required this.imageBase64,
  });

  Map<String, dynamic> toJson() {
    final dataUri = imageBase64.startsWith('data:')
        ? imageBase64
        : 'data:image/jpeg;base64,$imageBase64';

    return {
      'documentNumber': documentNumber,
      'imageBase64': dataUri,
    };
  }

  factory FaceVerificationRequest.fromJson(Map<String, dynamic> json) {
    return FaceVerificationRequest(
      documentNumber: json['documentNumber']?.toString() ?? json['document_number']?.toString() ?? '',
      imageBase64: json['faceImage']?.toString() ??
          json['image']?.toString() ??
          json['imageBase64']?.toString() ??
          json['selfie']?.toString() ??
          '',
    );
  }
}
