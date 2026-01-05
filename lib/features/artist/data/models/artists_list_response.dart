import 'artist_model.dart';

class ArtistsListResponse {
  final bool success;
  final String message;
  final ArtistsPayload payload;

  ArtistsListResponse({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory ArtistsListResponse.fromJson(Map<String, dynamic> json) {
    return ArtistsListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      payload: ArtistsPayload.fromJson(json['payload'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'payload': payload.toJson(),
    };
  }
}

class ArtistsPayload {
  final List<ArtistModel> artists;
  final int size;
  final int currentPage;
  final int totalPages;

  ArtistsPayload({
    required this.artists,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory ArtistsPayload.fromJson(Map<String, dynamic> json) {
    final pageList = json['page'] as List<dynamic>? ?? [];
    final artists = pageList
        .map((item) => ArtistModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ArtistsPayload(
      artists: artists,
      size: json['size'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': artists.map((e) => e.toJson()).toList(),
      'size': size,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}
