import 'influencer_model.dart';

class InfluencerResponse {
  final List<InfluencerModel> influencers;
  final int size;
  final int currentPage;
  final int totalPages;

  InfluencerResponse({
    required this.influencers,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory InfluencerResponse.fromJson(Map<String, dynamic> json) {
    return InfluencerResponse(
      influencers:
          (json['page'] as List?)
              ?.map(
                (item) =>
                    InfluencerModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      size: json['size'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
