import 'creative_model.dart';

class CreativeResponse {
  final List<CreativeModel> creatives;
  final int size;
  final int currentPage;
  final int totalPages;

  CreativeResponse({
    required this.creatives,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory CreativeResponse.fromJson(Map<String, dynamic> json) {
    return CreativeResponse(
      creatives: (json['page'] as List)
          .map((item) => CreativeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      size: json['size'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': creatives.map((c) => c.toJson()).toList(),
      'size': size,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}
