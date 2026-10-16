import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/service/session_service.dart';
import '../data/repositories/wall_repository.dart';
import '../data/models/wall_model.dart';

class WallNotifier extends StateNotifier<DataState<WallModel>> {
  final WallRepository _repository;
  Map<String, String?> selectedFilters = {};
  String searchQuery = '';
  List<WallModel> _allRawWalls = [];

  WallNotifier(this._repository) : super(DataState.initial()) {
    fetchWalls();
  }

  // Expose repository for file uploads
  WallRepository get repository => _repository;

  Future<void> updateFilters(Map<String, String?> filters) async {
    selectedFilters = Map.from(filters);
    await fetchWalls(refresh: true);
  }

  Future<void> removeFilter(String key) async {
    selectedFilters.remove(key);
    await fetchWalls(refresh: true);
  }

  Future<void> clearFilters() async {
    selectedFilters.clear();
    await fetchWalls(refresh: true);
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<WallModel> filtered = List.of(_allRawWalls);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((w) {
        return w.name.toLowerCase().contains(query) ||
            w.location.toLowerCase().contains(query) ||
            w.address.toLowerCase().contains(query);
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      selectedFilters.forEach((key, val) {
        if (val == null || val.isEmpty || val == 'All') return;
        final value = val.toLowerCase();
        if (key.toLowerCase() == 'location') {
          filtered = filtered
              .where((w) => w.location.toLowerCase().contains(value))
              .toList();
        } else if (key.toLowerCase() == 'wall type') {
          filtered = filtered
              .where((w) => w.type.toLowerCase().contains(value))
              .toList();
        } else if (key.toLowerCase() == 'status') {
          filtered = filtered
              .where((w) => w.status.toLowerCase() == value)
              .toList();
        } else if (key.toLowerCase() == 'price range') {
          final parts = val.split('-');
          if (parts.length == 2) {
            final min = double.tryParse(parts[0].trim()) ?? 0;
            final max = double.tryParse(parts[1].trim()) ?? double.infinity;
            filtered = filtered
                .where((w) => w.price >= min && w.price <= max)
                .toList();
          }
        }
      });
    }

    state = state.copyWith(
      data: filtered,
      isInitialLoading: false,
      isPaginating: false,
      isDataAvailable: filtered.isNotEmpty,
    );
  }

  Future<void> uploadWall(Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await _repository.createLocation(data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Wall uploaded successfully',
      );
      // Reload walls after upload
      await refreshWalls();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> updateWall(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await _repository.updateLocation(id, data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Wall updated successfully',
      );
      // Reload walls after update
      await refreshWalls();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteWall(String id) async {
    try {
      await _repository.deleteLocation(id);

      _allRawWalls.removeWhere((w) => w.id.toString() == id.toString());
      _applyFiltersAndEmit();
      await refreshWalls();
    } catch (e) {
      state = state.copyWith(
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshWalls() async {
    await fetchWalls(page: 0, size: 20, refresh: true);
  }

  Future<void> fetchWalls({
    int page = 0,
    int size = 20,
    bool refresh = false,
  }) async {
    if (refresh) {
      if ((state.data ?? []).isEmpty) {
        state = state.resetMessage().copyWith(isInitialLoading: true);
      } else {
        state = state.resetMessage();
      }
    } else if (state.isPaginating) {
      return;
    } else {
      state = state.copyWith(isPaginating: true);
    }

    try {
      final user = await SessionService.getUser();
      final userId = user != null ? (user['id'] ?? user['userId']) : null;

      final response = await _repository.getLocations(
        page: page,
        size: size,
        type: 'WALL',
        createdById: userId,
        search: searchQuery,
        filters: selectedFilters,
      );

      final List<dynamic> pageList = response['page'] ?? [];
      final List<WallModel> walls =
          pageList.map((item) => WallModel.fromJson(item)).toList();

      if (refresh) {
        _allRawWalls = walls;
      } else {
        _allRawWalls.addAll(walls);
      }

      _applyFiltersAndEmit();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        isPaginating: false,
        message: e.toString(),
      );
    }
  }
}
