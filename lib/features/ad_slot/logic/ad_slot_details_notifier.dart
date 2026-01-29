import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/ad_slot_service.dart';
import '../data/models/ad_slot_model.dart';

class AdSlotDetailsNotifier extends StateNotifier<DataState<AdSlot>> {
  final AdSlotService _service;

  AdSlotDetailsNotifier(this._service) : super(DataState.initial());

  Future<void> fetchAdSlotDetails(String id, {AdSlot? initialData}) async {
    // If we have initial data (e.g. from list), show it immediately
    if (initialData != null) {
      state = state.copyWith(
        isDataAvailable: true,
        singleData: initialData,
        isInitialLoading: true, // Still loading fresh data to get full details
      );
    } else {
      state = state.copyWith(isInitialLoading: true);
    }

    try {
      final adSlot = await _service.getAdSlotById(id);
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        singleData: adSlot,
        message: null,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        // Keep showing stale data if we have it, just show error message
        isDataAvailable: state.singleData != null,
        message: e.toString(),
      );
    }
  }
}

final adSlotServiceProvider = Provider<AdSlotService>((ref) {
  final apiClient = ApiClient();
  return AdSlotService(apiClient);
});

final adSlotDetailsProvider = StateNotifierProvider.family<
    AdSlotDetailsNotifier, DataState<AdSlot>, String>((ref, id) {
  final service = ref.watch(adSlotServiceProvider);
  return AdSlotDetailsNotifier(service);
});
