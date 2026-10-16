import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/data_state.dart';
import '../data/models/ad_slot_model.dart';
import '../data/repositories/ad_slot_repository.dart';

class AdSlotNotifier extends StateNotifier<DataState<AdSlotModel>> {
  final AdSlotRepository _repository;
  String searchQuery = '';
  String selectedPlatform = 'All';
  String selectedPartnerType = 'All';
  List<AdSlotModel> _allRawSlots = [];

  AdSlotNotifier(this._repository) : super(DataState.initial());

  void updateSearch(String query) {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void updatePlatform(String platform) {
    selectedPlatform = platform;
    _applyFiltersAndEmit();
  }

  void updatePartnerType(String partnerType) {
    selectedPartnerType = partnerType;
    _applyFiltersAndEmit();
  }

  void clearFilters() {
    searchQuery = '';
    selectedPlatform = 'All';
    selectedPartnerType = 'All';
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<AdSlotModel> filtered = List.from(_allRawSlots);

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered.where((slot) {
        final titleMatch = slot.title?.toLowerCase().contains(q) ?? false;
        final slotNumMatch = slot.slotNumber.toLowerCase().contains(q);
        final descMatch = slot.description?.toLowerCase().contains(q) ?? false;
        final platformMatch = slot.platforms?.any((p) => p.toLowerCase().contains(q)) ?? false;
        final partnerMatch = slot.partnerType?.toLowerCase().contains(q) ?? false;
        return titleMatch || slotNumMatch || descMatch || platformMatch || partnerMatch;
      }).toList();
    }

    if (selectedPlatform != 'All') {
      final target = selectedPlatform.toLowerCase();
      filtered = filtered.where((slot) {
        if (slot.platforms != null && slot.platforms!.isNotEmpty) {
          return slot.platforms!.any((p) => p.toLowerCase().contains(target));
        }
        return slot.parentType.toLowerCase().contains(target) ||
            (slot.title?.toLowerCase().contains(target) ?? false);
      }).toList();
    }

    if (selectedPartnerType != 'All') {
      final target = selectedPartnerType.toLowerCase();
      filtered = filtered.where((slot) {
        if (slot.partnerType != null && slot.partnerType!.isNotEmpty) {
          return slot.partnerType!.toLowerCase().contains(target);
        }
        if (slot.badge != null && slot.badge!.isNotEmpty) {
          return slot.badge!.toLowerCase().contains(target);
        }
        return true;
      }).toList();
    }

    state = state.copyWith(
      data: filtered,
      isInitialLoading: false,
      isPaginating: false,
      isDataAvailable: filtered.isNotEmpty,
    );
  }

  // Fetch slots for a specific parent (billboard/wall/screen)
  Future<void> fetchSlots(String parentId, String parentType) async {
    state = state.resetMessage().copyWith(isInitialLoading: true);
    
    try {
      final String? typeParam = (parentType == 'general' || parentType.isEmpty) ? null : parentType;
      final String? locationIdParam = (parentId == 'all' || parentId.isEmpty) ? null : parentId;

      final slots = await _repository.getAdSlots(
        type: typeParam,
        locationId: locationIdParam,
      );
      
      _allRawSlots = slots;
      _applyFiltersAndEmit();
    } catch (e) {
      state = state.copyWith(
        message: e.toString(),
        isInitialLoading: false,
      );
    }
  }

  // Add new slot
  Future<void> addSlot(Map<String, dynamic> slotData) async {
    try {
      final createdSlot = await _repository.createAdSlot(slotData);
      final List<AdSlotModel> updatedSlots = [...(state.data ?? []), createdSlot];
      state = state.copyWith(
        data: updatedSlots,
        isDataAvailable: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Update slot
  Future<void> updateSlot(String slotId, Map<String, dynamic> slotData) async {
    try {
      final updatedSlot = await _repository.updateAdSlot(slotId, slotData);
      
      final currentSlots = state.data ?? [];
      final updatedSlots = currentSlots.map((s) {
        return s.id == slotId ? updatedSlot : s;
      }).toList();

      state = state.copyWith(
        data: updatedSlots,
        isDataAvailable: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Delete slot
  Future<void> deleteSlot(String slotId) async {
    try {
      await _repository.deleteAdSlot(slotId);
      
      final currentSlots = state.data ?? [];
      final updatedSlots = currentSlots.where((s) => s.id != slotId).toList();

      state = state.copyWith(
        data: updatedSlots,
        isDataAvailable: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}
