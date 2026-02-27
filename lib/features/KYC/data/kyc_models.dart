/// KYC Data Models

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
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentType': documentType,
      'documentNumber': documentNumber,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  factory KycVerificationRequest.fromJson(Map<String, dynamic> json) {
    return KycVerificationRequest(
      documentType: json['documentType'] as String,
      documentNumber: json['documentNumber'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
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

class KycStatusResponse {
  final String status; // 'pending', 'approved', 'rejected'
  final String? message;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final KycVerificationRequest? submittedData;

  KycStatusResponse({
    required this.status,
    this.message,
    this.submittedAt,
    this.reviewedAt,
    this.submittedData,
  });

  factory KycStatusResponse.fromJson(Map<String, dynamic> json) {
    return KycStatusResponse(
      status: json['status'] as String,
      message: json['message'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      submittedData: json['submittedData'] != null
          ? KycVerificationRequest.fromJson(
              json['submittedData'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
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
    return {
      'documentNumber': documentNumber,
      'imageBase64': imageBase64,
    };
  }

  factory FaceVerificationRequest.fromJson(Map<String, dynamic> json) {
    return FaceVerificationRequest(
      documentNumber: json['documentNumber'] as String,
      imageBase64: json['imageBase64'] as String,
    );
  }
}
