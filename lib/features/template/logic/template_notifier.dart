import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import '../data/repositories/template_repository.dart';
import '../data/models/template_model.dart';

class TemplateNotifier extends StateNotifier<DataState<TemplateModel>> {
  final TemplateRepository repository;
  Map<String, String?> selectedFilters = {};
  String searchQuery = '';
  List<TemplateModel> _allRawTemplates = [];

  TemplateNotifier(this.repository) : super(DataState.initial()) {
    fetchTemplates();
  }

  Future<void> updateFilters(Map<String, String?> filters) async {
    selectedFilters = Map.from(filters);
    await fetchTemplates(refresh: true);
  }

  Future<void> removeFilter(String key) async {
    selectedFilters.remove(key);
    await fetchTemplates(refresh: true);
  }

  Future<void> clearFilters() async {
    selectedFilters.clear();
    await fetchTemplates(refresh: true);
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<TemplateModel> filtered = List.of(_allRawTemplates);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        return t.name.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query) ||
            (t.category != null && t.category!.toLowerCase().contains(query));
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      selectedFilters.forEach((key, val) {
        if (val == null || val.isEmpty || val == 'All') return;
        final value = val.toLowerCase();
        if (key.toLowerCase() == 'category') {
          filtered = filtered
              .where((t) => t.category?.toLowerCase().contains(value) ?? false)
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

  Future<void> refreshTemplates() async {
    await fetchTemplates(page: 0, size: 20, refresh: true);
  }

  Future<void> fetchTemplates({
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
      final response = await repository.getTemplates(
        page: page,
        size: size,
        search: searchQuery,
        filters: selectedFilters,
      );

      final List<dynamic> pageList = response['page'] ?? [];
      final List<TemplateModel> templates = pageList.map((item) => TemplateModel.fromJson(item)).toList();

      if (refresh) {
        _allRawTemplates = templates;
      } else {
        _allRawTemplates.addAll(templates);
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

  Future<bool> createTemplate(Map<String, dynamic> payload) async {
    try {
      state = state.resetMessage().copyWith(isInitialLoading: true);
      await repository.createTemplate(payload);
      
      // Refresh the templates list
      await refreshTemplates();
      
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
