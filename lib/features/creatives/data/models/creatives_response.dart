import 'creative_model.dart';

class CreativesResponse {
  final CreativesPayload payload;

  CreativesResponse({required this.payload});

  factory CreativesResponse.fromJson(Map<String, dynamic> json) {
    return CreativesResponse(
      payload: CreativesPayload.fromJson(json['payload'] ?? {}),
    );
  }
}

class CreativesPayload {
  final List<CreativeModel> creatives;
  final int size;
  final int currentPage;
  final int totalPages;

  CreativesPayload({
    required this.creatives,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory CreativesPayload.fromJson(Map<String, dynamic> json) {
    return CreativesPayload(
      creatives: (json['page'] as List<dynamic>?)
              ?.map((item) => CreativeModel.fromJson(item))
              .toList() ??
          [],
      size: json['size'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
