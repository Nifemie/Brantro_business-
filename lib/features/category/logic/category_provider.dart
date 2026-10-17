import 'package:brantro_business/core/constants/template_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/repositories/category_repository.dart';
import '../data/models/category_model.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CategoryRepository(apiClient);
});

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});

class CategoryState {
  final List<CategoryModel> categories;
  final List<CategoryModel> locationCategories;
  final List<CategoryModel> templateCategories;
  final bool isLoading;
  final String? error;

  CategoryState({
    this.categories = const [],
    this.locationCategories = const [],
    this.templateCategories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    List<CategoryModel>? locationCategories,
    List<CategoryModel>? templateCategories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      locationCategories: locationCategories ?? this.locationCategories,
      templateCategories: templateCategories ?? this.templateCategories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CategoryNotifier extends StateNotifier<CategoryState> {
  final CategoryRepository _repository;

  CategoryNotifier(this._repository) : super(CategoryState()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final serviceCategories = await _repository.getCategories(type: 'SERVICE');
      final creativeCategories = await _repository.getCategories(type: 'CREATIVE');
      final combinedCategories = [...serviceCategories, ...creativeCategories];
      
      final locationCategories = await _repository.getCategories(type: 'LOCATION');
      var templateCategories = await _repository.getCategories(type: 'TEMPLATE');

      // Seed default template categories if backend returns none (BRT-025)
      if (templateCategories.isEmpty) {
        final now = DateTime.now();
        templateCategories = TemplateConstants.templateCategories
            .asMap()
            .entries
            .map((entry) => CategoryModel(
                  id: entry.key + 1,
                  name: entry.value,
                  type: 'TEMPLATE',
                  description: '${entry.value} Templates',
                  status: 'ACTIVE',
                  createdById: 1,
                  createdAt: now,
                  updatedAt: now,
                ))
            .toList();
      }

      state = state.copyWith(
        categories: combinedCategories,
        locationCategories: locationCategories,
        templateCategories: templateCategories,
        isLoading: false,
      );
    } catch (e) {
      final now = DateTime.now();
      final defaultTemplates = TemplateConstants.templateCategories
          .asMap()
          .entries
          .map((entry) => CategoryModel(
                id: entry.key + 1,
                name: entry.value,
                type: 'TEMPLATE',
                description: '${entry.value} Templates',
                status: 'ACTIVE',
                createdById: 1,
                createdAt: now,
                updatedAt: now,
              ))
          .toList();

      state = state.copyWith(
        isLoading: false,
        templateCategories: state.templateCategories.isNotEmpty ? state.templateCategories : defaultTemplates,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadCategories();
  }
}
