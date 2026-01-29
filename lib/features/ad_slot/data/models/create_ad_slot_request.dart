class CreateAdSlotRequest {
  final String partnerType;
  final String platform;
  final String contentType;
  final double price;
  final String duration;
  final int? maxRevisions;
  final String? coverageArea;
  final String audienceSize;
  final String? timeWindow;

  CreateAdSlotRequest({
    required this.partnerType,
    required this.platform,
    required this.contentType,
    required this.price,
    required this.duration,
    this.maxRevisions,
    this.coverageArea,
    required this.audienceSize,
    this.timeWindow,
  });

  Map<String, dynamic> toJson() {
    return {
      'partnerType': partnerType,
      'platform': platform,
      'contentType': contentType,
      'price': price,
      'duration': duration,
      if (maxRevisions != null) 'maxRevisions': maxRevisions,
      if (coverageArea != null) 'coverageArea': coverageArea,
      'audienceSize': audienceSize,
      if (timeWindow != null) 'timeWindow': timeWindow,
    };
  }
}
