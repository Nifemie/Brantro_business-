import 'service_model.dart';

class ServicesResponse {
  final List<ServiceModel> services;
  final int currentPage;
  final int size;
  final int totalPages;

  ServicesResponse({
    required this.services,
    required this.currentPage,
    required this.size,
    required this.totalPages,
  });

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      services: (json['page'] as List<dynamic>?)
              ?.map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: int.tryParse(json['currentPage']?.toString() ?? '0') ?? 0,
      size: int.tryParse(json['size']?.toString() ?? '10') ?? 10,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  bool get hasMore => currentPage < totalPages - 1;
}
