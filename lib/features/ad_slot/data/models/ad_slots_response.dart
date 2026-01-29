import 'ad_slot_model.dart';

class AdSlotsResponse {
  final List<AdSlot> adSlots;
  final int currentPage;
  final int size;
  final int totalPages;

  AdSlotsResponse({
    required this.adSlots,
    required this.currentPage,
    required this.size,
    required this.totalPages,
  });

  factory AdSlotsResponse.fromJson(Map<String, dynamic> json) {
    return AdSlotsResponse(
      adSlots: (json['page'] as List?)
              ?.map((item) => AdSlot.fromJson(item))
              .toList() ??
          [],
      currentPage: int.tryParse(json['currentPage']?.toString() ?? '0') ?? 0,
      size: int.tryParse(json['size']?.toString() ?? '20') ?? 20,
      totalPages: int.tryParse(json['totalPages']?.toString() ?? '0') ?? 0,
    );
  }

  bool get hasMore => currentPage < totalPages - 1;
}
