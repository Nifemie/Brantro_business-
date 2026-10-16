import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/service/session_service.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/models/vehicle_model.dart';

class VehicleNotifier extends StateNotifier<DataState<VehicleModel>> {
  final VehicleRepository repository;
  Map<String, String?> selectedFilters = {};
  String searchQuery = '';
  List<VehicleModel> _allRawVehicles = [];

  VehicleNotifier(this.repository) : super(DataState.initial()) {
    fetchVehicles();
  }

  Future<void> updateFilters(Map<String, String?> filters) async {
    selectedFilters = Map.from(filters);
    await fetchVehicles(refresh: true);
  }

  Future<void> removeFilter(String key) async {
    selectedFilters.remove(key);
    await fetchVehicles(refresh: true);
  }

  Future<void> clearFilters() async {
    selectedFilters.clear();
    await fetchVehicles(refresh: true);
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<VehicleModel> filtered = List.of(_allRawVehicles);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((v) {
        return v.name.toLowerCase().contains(query) ||
            v.location.toLowerCase().contains(query) ||
            v.address.toLowerCase().contains(query);
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      selectedFilters.forEach((key, val) {
        if (val == null || val.isEmpty || val == 'All') return;
        final value = val.toLowerCase();
        if (key.toLowerCase() == 'location') {
          filtered = filtered
              .where((v) => v.location.toLowerCase().contains(value))
              .toList();
        } else if (key.toLowerCase() == 'vehicle type') {
          filtered = filtered
              .where((v) => v.type.toLowerCase().contains(value))
              .toList();
        } else if (key.toLowerCase() == 'status') {
          filtered = filtered
              .where((v) => v.status.toLowerCase() == value)
              .toList();
        } else if (key.toLowerCase() == 'price range') {
          final parts = val.split('-');
          if (parts.length == 2) {
            final min = double.tryParse(parts[0].trim()) ?? 0;
            final max = double.tryParse(parts[1].trim()) ?? double.infinity;
            filtered = filtered
                .where((v) => v.price >= min && v.price <= max)
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

  Future<void> uploadVehicle(Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await repository.createLocation(data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Vehicle uploaded successfully',
      );
      // Reload vehicles after upload
      await refreshVehicles();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await repository.updateLocation(id, data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Vehicle updated successfully',
      );
      // Reload vehicles after update
      await refreshVehicles();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await repository.deleteLocation(id);

      _allRawVehicles.removeWhere((v) => v.id.toString() == id.toString());
      _applyFiltersAndEmit();
      await refreshVehicles();
    } catch (e) {
      state = state.copyWith(
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshVehicles() async {
    await fetchVehicles(page: 0, size: 20, refresh: true);
  }

  Future<void> fetchVehicles({
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

      final response = await repository.getLocations(
        page: page,
        size: size,
        type: 'VEHICLE',
        createdById: userId,
        search: searchQuery,
        filters: selectedFilters,
      );

      final List<dynamic> pageList = response['page'] ?? [];
      final List<VehicleModel> vehicles =
          pageList.map((item) => VehicleModel.fromJson(item)).toList();

      if (refresh) {
        _allRawVehicles = vehicles;
      } else {
        _allRawVehicles.addAll(vehicles);
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
