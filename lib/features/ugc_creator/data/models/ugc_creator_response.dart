import 'ugc_creator_model.dart';

class UgcCreatorResponse {
  final List<UgcCreatorModel> ugcCreators;
  final int size;
  final int currentPage;
  final int totalPages;

  UgcCreatorResponse({
    required this.ugcCreators,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory UgcCreatorResponse.fromJson(Map<String, dynamic> json) {
    return UgcCreatorResponse(
      ugcCreators: (json['page'] as List)
          .map((item) => UgcCreatorModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      size: json['size'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': ugcCreators.map((u) => u.toJson()).toList(),
      'size': size,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}
