import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/ad_slot_model.dart';

class AdSlotState {
  final List<AdSlotModel> slots;
  final bool isLoading;
  final String? error;

  AdSlotState({
    this.slots = const [],
    this.isLoading = false,
    this.error,
  });

  AdSlotState copyWith({
    List<AdSlotModel>? slots,
    bool? isLoading,
    String? error,
  }) {
    return AdSlotState(
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AdSlotNotifier extends StateNotifier<AdSlotState> {
  AdSlotNotifier() : super(AdSlotState());

  // Fetch slots for a specific parent (billboard/wall/screen)
  Future<void> fetchSlots(String parentId, String parentType) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      final mockSlots = _generateMockSlots(parentId, parentType);
      
      state = state.copyWith(slots: mockSlots, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // Add new slot
  Future<void> addSlot(AdSlotModel slot) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedSlots = [...state.slots, slot];
      state = state.copyWith(slots: updatedSlots);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Update slot
  Future<void> updateSlot(String slotId, AdSlotModel updatedSlot) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedSlots = state.slots.map((slot) {
        return slot.id == slotId ? updatedSlot : slot;
      }).toList();
      
      state = state.copyWith(slots: updatedSlots);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Delete slot
  Future<void> deleteSlot(String slotId) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedSlots = state.slots.where((slot) => slot.id != slotId).toList();
      state = state.copyWith(slots: updatedSlots);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  List<AdSlotModel> _generateMockSlots(String parentId, String parentType) {
    return [
      AdSlotModel(
        id: '1',
        parentId: parentId,
        parentType: parentType,
        slotNumber: 'Slot 1',
        duration: 30,
        price: 500000,
        status: 'available',
        maxRevisions: 2,
        audience: '100k - 500k',
        createdAt: DateTime.now(),
      ),
      AdSlotModel(
        id: '2',
        parentId: parentId,
        parentType: parentType,
        slotNumber: 'Slot 2',
        duration: 30,
        price: 500000,
        status: 'booked',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        bookedBy: 'Acme Corporation',
        maxRevisions: 3,
        audience: '200k - 1M',
        createdAt: DateTime.now(),
      ),
      AdSlotModel(
        id: '3',
        parentId: parentId,
        parentType: parentType,
        slotNumber: 'Slot 3',
        duration: 14,
        price: 250000,
        status: 'available',
        maxRevisions: 1,
        audience: '50k - 200k',
        createdAt: DateTime.now(),
      ),
    ];
  }
}

final adSlotProvider = StateNotifierProvider<AdSlotNotifier, AdSlotState>((ref) {
  return AdSlotNotifier();
});
