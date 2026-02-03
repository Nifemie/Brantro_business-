import 'campaign_model.dart';

class CampaignsResponse {
  final bool success;
  final String message;
  final CampaignsPayload? payload;

  CampaignsResponse({
    required this.success,
    required this.message,
    this.payload,
  });

  factory CampaignsResponse.fromJson(Map<String, dynamic> json) {
    return CampaignsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      payload: json['payload'] != null 
          ? CampaignsPayload.fromJson(json['payload']) 
          : null,
    );
  }
}

class CampaignsPayload {
  final List<CampaignModel> page;
  final String size;
  final int currentPage;
  final int totalPages;

  CampaignsPayload({
    required this.page,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory CampaignsPayload.fromJson(Map<String, dynamic> json) {
    return CampaignsPayload(
      page: (json['page'] as List<dynamic>)
          .map((c) => CampaignModel.fromJson(c))
          .toList(),
      size: json['size'] as String,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
