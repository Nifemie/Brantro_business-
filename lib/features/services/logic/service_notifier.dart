import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import '../data/repositories/service_repository.dart';
import '../data/models/service_model.dart';

class ServiceNotifier extends StateNotifier<DataState<ServiceModel>> {
  final ServiceRepository repository;
  Map<String, String?> selectedFilters = {};
  String searchQuery = '';
  List<ServiceModel> _allRawServices = [];

  ServiceNotifier(this.repository) : super(DataState.initial()) {
    fetchServices();
  }

  Future<void> updateFilters(Map<String, String?> filters) async {
    selectedFilters = Map.from(filters);
    await fetchServices(refresh: true);
  }

  Future<void> removeFilter(String key) async {
    selectedFilters.remove(key);
    await fetchServices(refresh: true);
  }

  Future<void> clearFilters() async {
    selectedFilters.clear();
    await fetchServices(refresh: true);
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<ServiceModel> filtered = List.of(_allRawServices);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((s) {
        return s.title.toLowerCase().contains(query) ||
            s.description.toLowerCase().contains(query) ||
            (s.category != null && s.category!.toLowerCase().contains(query));
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      selectedFilters.forEach((key, val) {
        if (val == null || val.isEmpty || val == 'All') return;
        final value = val.toLowerCase();
        if (key.toLowerCase() == 'category') {
          filtered = filtered
              .where((s) => s.category?.toLowerCase().contains(value) ?? false)
              .toList();
        }
      });
    }

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = state.copyWith(
      data: filtered,
      isInitialLoading: false,
      isPaginating: false,
      isDataAvailable: filtered.isNotEmpty,
    );
  }

  Future<void> refreshServices() async {
    await fetchServices(page: 0, size: 20, refresh: true);
  }

  Future<void> fetchServices({
    int page = 0,
    int size = 20,
    dynamic createdById,
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
      final response = await repository.getServices(
        page: page,
        size: size,
        createdById: createdById,
        search: searchQuery,
        filters: selectedFilters,
      );

      final List<dynamic> pageList = response['page'] ?? [];
      final List<ServiceModel> services = pageList.map((item) => ServiceModel.fromJson(item)).toList();

      if (refresh) {
        _allRawServices = services;
      } else {
        _allRawServices.addAll(services);
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

  Future<bool> createService(Map<String, dynamic> payload) async {
    try {
      state = state.resetMessage().copyWith(isInitialLoading: true);
      await repository.createService(payload);
      
      // Refresh the services list
      await refreshServices();
      
      state = state.copyWith(isInitialLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      return false;
    }
  }
}
