import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import '../data/repositories/creative_repository.dart';
import '../data/models/creative_model.dart';

class CreativeNotifier extends StateNotifier<DataState<CreativeModel>> {
  final CreativeRepository repository;
  Map<String, String?> selectedFilters = {};
  String searchQuery = '';
  List<CreativeModel> _allRawCreatives = [];

  CreativeNotifier(this.repository) : super(DataState.initial()) {
    fetchCreatives();
  }

  Future<void> updateFilters(Map<String, String?> filters) async {
    selectedFilters = Map.from(filters);
    await fetchCreatives(refresh: true);
  }

  Future<void> removeFilter(String key) async {
    selectedFilters.remove(key);
    await fetchCreatives(refresh: true);
  }

  Future<void> clearFilters() async {
    selectedFilters.clear();
    await fetchCreatives(refresh: true);
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<CreativeModel> filtered = List.of(_allRawCreatives);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.description.toLowerCase().contains(query) ||
            (c.category != null && c.category!.toLowerCase().contains(query));
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      selectedFilters.forEach((key, val) {
        if (val == null || val.isEmpty || val == 'All') return;
        final value = val.toLowerCase();
        if (key.toLowerCase() == 'category') {
          filtered = filtered
              .where((c) => c.category?.toLowerCase().contains(value) ?? false)
              .toList();
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

  Future<void> refreshCreatives() async {
    await fetchCreatives(page: 0, size: 20, refresh: true);
  }

  Future<void> fetchCreatives({
    int page = 0,
    int size = 20,
    bool refresh = false,
  }) async {
    if (refresh || (state.data ?? []).isEmpty) {
      state = state.resetMessage().copyWith(isInitialLoading: true);
    } else if (state.isPaginating) {
      return;
    } else {
      state = state.copyWith(isPaginating: true);
    }

    try {
      final response = await repository.getCreatives(
        page: page,
        size: size,
        search: searchQuery,
        filters: selectedFilters,
      );

      final List<dynamic> pageList = response['page'] ?? [];
      final List<CreativeModel> creatives = pageList.map((item) => CreativeModel.fromJson(item)).toList();

      if (refresh) {
        _allRawCreatives = creatives;
      } else {
        _allRawCreatives.addAll(creatives);
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

  Future<bool> createCreative(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(isInitialLoading: true, message: null);
      final success = await repository.createCreative(data);
      if (success) {
        // Refresh the list after successful creation
        await refreshCreatives();
        state = state.copyWith(isInitialLoading: false);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      return false;
    }
  }
}
