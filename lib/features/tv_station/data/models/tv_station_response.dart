import 'tv_station_model.dart';

class TvStationResponse {
  final List<TvStationModel> page;
  final int size;
  final int currentPage;
  final int totalPages;

  TvStationResponse({
    required this.page,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory TvStationResponse.fromJson(Map<String, dynamic> json) {
    return TvStationResponse(
      page: (json['page'] as List)
          .map((item) => TvStationModel.fromJson(item as Map<String, dynamic>))
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
