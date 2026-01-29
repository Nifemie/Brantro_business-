import 'billboard_model.dart';

class BillboardsListResponse {
  final BillboardsPayload payload;

  BillboardsListResponse({required this.payload});

  factory BillboardsListResponse.fromJson(Map<String, dynamic> json) {
    return BillboardsListResponse(
      payload: BillboardsPayload.fromJson(json['payload'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payload': payload.toJson(),
    };
  }
}

class BillboardsPayload {
  final List<BillboardModel> billboards;
  final String currentPage;
  final int size;
  final int totalPages;

  BillboardsPayload({
    required this.billboards,
    required this.currentPage,
    required this.size,
    required this.totalPages,
  });

  factory BillboardsPayload.fromJson(Map<String, dynamic> json) {
    return BillboardsPayload(
      billboards: (json['page'] as List<dynamic>?)
              ?.map((item) => BillboardModel.fromJson(item))
              .toList() ??
          [],
      currentPage: json['currentPage']?.toString() ?? '0',
      size: json['size'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': billboards.map((billboard) => billboard.toJson()).toList(),
      'currentPage': currentPage,
      'size': size,
      'totalPages': totalPages,
    };
  }
}
