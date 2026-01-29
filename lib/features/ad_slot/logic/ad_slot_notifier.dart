import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/ad_slot_service.dart';
import '../data/models/ad_slot_model.dart';

// Notifier
class AdSlotNotifier extends StateNotifier<DataState<AdSlot>> {
  final AdSlotService _adSlotService;

  AdSlotNotifier(this._adSlotService) : super(DataState.initial());

  // Convert technical errors to user-friendly messages
  String _getUserFriendlyError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('socketexception') || 
        errorString.contains('failed host lookup') ||
        errorString.contains('connection error')) {
      return 'No internet connection. Please check your network.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return 'Session expired. Please log in again.';
    } else if (errorString.contains('404')) {
      return 'Resource not found.';
    } else if (errorString.contains('500') || errorString.contains('502') || errorString.contains('503')) {
      return 'Server error. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  Future<void> loadAdSlots({bool refresh = false}) async {
    log('[AdSlotNotifier] Loading ad slots, refresh=$refresh');
    
    if (refresh) {
      state = DataState.initial();
    }
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _adSlotService.fetchAdSlots(page: 0, size: 20);
      log('[AdSlotNotifier] Successfully loaded ${response.adSlots.length} ad slots');
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.adSlots,
        currentPage: response.currentPage,
        totalPages: response.hasMore ? response.currentPage + 2 : response.currentPage + 1,
        message: null,
      );
    } catch (e, stack) {
      log('[AdSlotNotifier] Error loading ad slots: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: _getUserFriendlyError(e),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isPaginating || !state.isDataAvailable) return;
    
    final nextPage = state.currentPage + 1;
    if (nextPage >= state.totalPages) return;

    log('[AdSlotNotifier] Loading more ad slots, page=$nextPage');
    
    state = state.copyWith(isPaginating: true, message: null);

    try {
      final response = await _adSlotService.fetchAdSlots(
        page: nextPage,
        size: 20,
      );
      log('[AdSlotNotifier] Successfully loaded ${response.adSlots.length} more ad slots');

      state = state.copyWith(
        isPaginating: false,
        data: [...(state.data ?? []), ...response.adSlots],
        currentPage: response.currentPage,
        totalPages: response.hasMore ? response.currentPage + 2 : response.currentPage + 1,
        message: null,
      );
    } catch (e, stack) {
      log('[AdSlotNotifier] Error loading more ad slots: $e\n$stack');
      state = state.copyWith(
        isPaginating: false,
        message: _getUserFriendlyError(e),
      );
    }
  }

  List<AdSlot> getAdSlotsByPartnerType(String partnerType) {
    return (state.data ?? [])
        .where(
          (slot) => slot.partnerType.toUpperCase() == partnerType.toUpperCase(),
        )
        .toList();
  }

  Future<void> searchAdSlots({required String query}) async {
    if (query.isEmpty) {
      // Reset to all ad slots if query is empty
      await loadAdSlots(refresh: true);
      return;
    }

    log('[AdSlotNotifier] Searching ad slots with query: $query');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _adSlotService.searchAdSlots(
        query: query,
        page: 0,
        size: 20,
      );
      log('[AdSlotNotifier] Successfully found ${response.adSlots.length} ad slots');
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.adSlots,
        currentPage: response.currentPage,
        totalPages: response.hasMore ? response.currentPage + 2 : response.currentPage + 1,
        message: null,
      );
    } catch (e, stack) {
      log('[AdSlotNotifier] Error searching ad slots: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: _getUserFriendlyError(e),
      );
    }
  }

  /// Clear any error messages
  void clearMessage() {
    state = state.copyWith(message: null);
  }

  /// Reset state to initial
  void reset() {
    state = DataState.initial();
  }
}

// Provider
final adSlotProvider = StateNotifierProvider<AdSlotNotifier, DataState<AdSlot>>(
  (ref) {
    final apiClient = ApiClient();
    final adSlotService = AdSlotService(apiClient);
    final notifier = AdSlotNotifier(adSlotService);
    notifier.loadAdSlots(); // Auto-load on initialization
    return notifier;
  },
);
