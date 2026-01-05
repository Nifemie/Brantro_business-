import 'media_house_model.dart';

class MediaHouseResponse {
  final List<MediaHouseModel> page;
  final int size;
  final int currentPage;
  final int totalPages;

  MediaHouseResponse({
    required this.page,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory MediaHouseResponse.fromJson(Map<String, dynamic> json) {
    return MediaHouseResponse(
      page: (json['page'] as List)
          .map((item) => MediaHouseModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      size: json['size'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page.map((item) => item.toJson()).toList(),
    'size': size,
    'currentPage': currentPage,
    'totalPages': totalPages,
  };
}
