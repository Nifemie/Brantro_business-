import 'radio_station_model.dart';

class RadioStationResponse {
  final List<RadioStationModel> page;
  final int size;
  final int currentPage;
  final int totalPages;

  RadioStationResponse({
    required this.page,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory RadioStationResponse.fromJson(Map<String, dynamic> json) {
    return RadioStationResponse(
      page: (json['page'] as List)
          .map(
            (item) => RadioStationModel.fromJson(item as Map<String, dynamic>),
          )
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
