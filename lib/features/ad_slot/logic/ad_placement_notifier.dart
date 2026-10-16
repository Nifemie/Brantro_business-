import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/ad_placement_model.dart';
import '../data/repositories/ad_placement_repository.dart';

class AdPlacementState {
  final List<AdPlacementModel>? data;
  final bool isLoading;
  final bool isInitialLoading;
  final String? error;

  AdPlacementState({
    this.data,
    this.isLoading = false,
    this.isInitialLoading = false,
    this.error,
  });

  AdPlacementState copyWith({
    List<AdPlacementModel>? data,
    bool? isLoading,
    bool? isInitialLoading,
    String? error,
  }) {
    return AdPlacementState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      error: error,
    );
  }
}

class AdPlacementNotifier extends StateNotifier<AdPlacementState> {
  final AdPlacementRepository repository;
  final String campaignOrderId;
  int _currentPage = 0;
  bool _hasMore = true;
  String? _currentQuery;

  AdPlacementNotifier(this.repository, this.campaignOrderId) : super(AdPlacementState()) {
    _fetchInitial();
  }

  Future<void> _fetchInitial() async {
    state = state.copyWith(isInitialLoading: true, error: null);
    try {
      final placements = await repository.fetchAdPlacements(
        page: 0,
        campaignOrderId: campaignOrderId,
      );
      _currentPage = 1;
      _hasMore = placements.isNotEmpty;
      state = state.copyWith(data: placements, isInitialLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isInitialLoading: false);
    }
  }

  Future<void> search(String query) async {
    _currentQuery = query.trim().isEmpty ? null : query.trim();
    _currentPage = 0;
    _hasMore = true;
    
    if (_currentQuery == null) {
      await _fetchInitial();
      return;
    }

    state = state.copyWith(isInitialLoading: true, error: null);
    try {
      final placements = await repository.searchAdPlacements(
        query: _currentQuery!,
        page: 0,
      );
      _currentPage = 1;
      _hasMore = placements.isNotEmpty;
      state = state.copyWith(data: placements, isInitialLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isInitialLoading: false);
    }
  }

  Future<void> refresh() async {
    _currentPage = 0;
    _hasMore = true;
    if (_currentQuery != null) {
      await search(_currentQuery!);
    } else {
      await _fetchInitial();
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      List<AdPlacementModel> newPlacements;
      if (_currentQuery != null) {
        newPlacements = await repository.searchAdPlacements(
          query: _currentQuery!,
          page: _currentPage,
        );
      } else {
        newPlacements = await repository.fetchAdPlacements(
          page: _currentPage,
          campaignOrderId: campaignOrderId,
        );
      }

      if (newPlacements.isEmpty) {
        _hasMore = false;
        state = state.copyWith(isLoading: false);
      } else {
        _currentPage++;
        final currentData = state.data ?? [];
        state = state.copyWith(
          data: [...currentData, ...newPlacements],
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> acceptPlacement(int id) async {
    try {
      final updatedPlacement = await repository.acceptPlacement(id);
      
      if (state.data != null) {
        final currentData = List<AdPlacementModel>.from(state.data!);
        final index = currentData.indexWhere((p) => p.id == id);
        
        if (index != -1) {
          currentData[index] = updatedPlacement;
          state = state.copyWith(data: currentData);
        }
      }
    } catch (e) {
      // Re-throw so the UI can show a snackbar
      rethrow;
    }
  }

  Future<void> rejectPlacement(int id, String reason) async {
    try {
      final updatedPlacement = await repository.rejectPlacement(id, reason);
      
      if (state.data != null) {
        final currentData = List<AdPlacementModel>.from(state.data!);
        final index = currentData.indexWhere((p) => p.id == id);
        
        if (index != -1) {
          currentData[index] = updatedPlacement;
          state = state.copyWith(data: currentData);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> inProgressPlacement(int id) async {
    try {
      final updatedPlacement = await repository.inProgressPlacement(id);
      
      if (state.data != null) {
        final currentData = List<AdPlacementModel>.from(state.data!);
        final index = currentData.indexWhere((p) => p.id == id);
        
        if (index != -1) {
          currentData[index] = updatedPlacement;
          state = state.copyWith(data: currentData);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completePlacement(int id) async {
    try {
      final updatedPlacement = await repository.completePlacement(id);
      
      if (state.data != null) {
        final currentData = List<AdPlacementModel>.from(state.data!);
        final index = currentData.indexWhere((p) => p.id == id);
        
        if (index != -1) {
          currentData[index] = updatedPlacement;
          state = state.copyWith(data: currentData);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelPlacement(int id, String reason) async {
    try {
      final updatedPlacement = await repository.cancelPlacement(id, reason);
      
      if (state.data != null) {
        final currentData = List<AdPlacementModel>.from(state.data!);
        final index = currentData.indexWhere((p) => p.id == id);
        
        if (index != -1) {
          currentData[index] = updatedPlacement;
          state = state.copyWith(data: currentData);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadProof(int id, Map<String, dynamic> data) async {
    try {
      await repository.uploadProof(id, data);
    } catch (e) {
      rethrow;
    }
  }
}
