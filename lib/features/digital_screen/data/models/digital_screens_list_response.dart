import 'digital_screen_model.dart';

class DigitalScreensListResponse {
  final DigitalScreensPayload payload;

  DigitalScreensListResponse({required this.payload});

  factory DigitalScreensListResponse.fromJson(Map<String, dynamic> json) {
    return DigitalScreensListResponse(
      payload: DigitalScreensPayload.fromJson(json['payload'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payload': payload.toJson(),
    };
  }
}

class DigitalScreensPayload {
  final List<DigitalScreenModel> screens;
  final String currentPage;
  final int size;
  final int totalPages;

  DigitalScreensPayload({
    required this.screens,
    required this.currentPage,
    required this.size,
    required this.totalPages,
  });

  factory DigitalScreensPayload.fromJson(Map<String, dynamic> json) {
    return DigitalScreensPayload(
      screens: (json['page'] as List<dynamic>?)
              ?.map((item) => DigitalScreenModel.fromJson(item))
              .toList() ??
          [],
      currentPage: json['currentPage']?.toString() ?? '0',
      size: json['size'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': screens.map((screen) => screen.toJson()).toList(),
      'currentPage': currentPage,
      'size': size,
      'totalPages': totalPages,
    };
  }
}
