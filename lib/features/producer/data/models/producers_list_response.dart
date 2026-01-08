import 'producer_model.dart';

class ProducersListResponse {
  final bool success;
  final String message;
  final ProducersPayload payload;

  ProducersListResponse({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory ProducersListResponse.fromJson(Map<String, dynamic> json) {
    return ProducersListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      payload: ProducersPayload.fromJson(json['payload'] as Map<String, dynamic>),
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

class ProducersPayload {
  final List<ProducerModel> producers;
  final int size;
  final int currentPage;
  final int totalPages;

  ProducersPayload({
    required this.producers,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory ProducersPayload.fromJson(Map<String, dynamic> json) {
    return ProducersPayload(
      producers: (json['page'] as List<dynamic>)
          .map((e) => ProducerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      size: json['size'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': producers.map((e) => e.toJson()).toList(),
      'size': size,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}
