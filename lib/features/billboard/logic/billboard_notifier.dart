import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/service/session_service.dart';
import '../data/repositories/billboard_repository.dart';
import '../data/models/billboard_model.dart';

class BillboardNotifier extends StateNotifier<DataState<BillboardModel>> {
  final BillboardRepository _repository;
  Map<String, String?> selectedFilters = {};
  String searchQuery = '';
  List<BillboardModel> _allRawBillboards = [];

  BillboardNotifier(this._repository) : super(DataState.initial()) {
    fetchBillboards();
  }

  Future<void> updateFilters(Map<String, String?> filters) async {
    selectedFilters = Map.from(filters);
    await fetchBillboards(refresh: true);
  }

  Future<void> removeFilter(String key) async {
    selectedFilters.remove(key);
    await fetchBillboards(refresh: true);
  }

  Future<void> clearFilters() async {
    selectedFilters.clear();
    await fetchBillboards(refresh: true);
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void search(String query) {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<BillboardModel> filtered = List.from(_allRawBillboards);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((b) =>
            b.name.toLowerCase().contains(query) ||
            b.location.toLowerCase().contains(query) ||
            b.address.toLowerCase().contains(query) ||
            b.description.toLowerCase().contains(query) ||
            b.featuresText.toLowerCase().contains(query)).toList();
    }

    selectedFilters.forEach((k, v) {
      if (v != null && v.isNotEmpty && v != 'All') {
        final value = v.toLowerCase();
        if (k == 'location') {
          filtered = filtered.where((b) => b.location.toLowerCase().contains(value)).toList();
        } else if (k == 'status') {
          filtered = filtered.where((b) => b.status.toLowerCase() == value).toList();
        } else if (k == 'type') {
          filtered = filtered.where((b) => b.type.toLowerCase().contains(value)).toList();
        } else if (k == 'rating') {
          final rating = double.tryParse(v) ?? 0.0;
          filtered = filtered.where((b) => (b.averageRating ?? 0.0) >= rating).toList();
        }
      }
    });

    state = state.copyWith(
      isInitialLoading: false,
      isPaginating: false,
      data: filtered,
    );
  }

  Future<void> uploadBillboard(Map<String, dynamic> data) async {
    await createBillboard(data);
  }

  Future<BillboardModel> createBillboard(Map<String, dynamic> data) async {
    try {
      final response = await _repository.createLocation(data);
      final newBillboard = BillboardModel.fromJson(response);
      _allRawBillboards.insert(0, newBillboard);
      _applyFiltersAndEmit();
      return newBillboard;
    } catch (e) {
      state = state.copyWith(
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<BillboardModel> updateBillboard(String id, Map<String, dynamic> data) async {
    try {
      final response = await _repository.updateLocation(id, data);
      final updated = BillboardModel.fromJson(response);
      final index = _allRawBillboards.indexWhere((b) => b.id == id);
      if (index != -1) {
        _allRawBillboards[index] = updated;
        _applyFiltersAndEmit();
      }
      return updated;
    } catch (e) {
      state = state.copyWith(
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteBillboard(String id) async {
    try {
      await _repository.deleteLocation(id);
      _allRawBillboards.removeWhere((b) => b.id == id);
      _applyFiltersAndEmit();
    } catch (e) {
      state = state.copyWith(
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshBillboards() async {
    await fetchBillboards(page: 0, size: 20, refresh: true);
  }

  Future<void> fetchBillboards({
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
        type: 'BILLBOARD',
        createdById: userId,
        search: searchQuery,
        filters: selectedFilters,
      );

      final List<dynamic> pageList = response['page'] ?? [];
      final List<BillboardModel> billboards = pageList.map((item) => BillboardModel.fromJson(item)).toList();
      
      if (refresh) {
        _allRawBillboards = billboards;
      } else {
        _allRawBillboards.addAll(billboards);
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
