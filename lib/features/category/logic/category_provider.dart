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
      final categories = await _repository.getCategories();
      final locationCategories = categories.where((cat) => cat.type == 'LOCATION').toList();
      final templateCategories = categories.where((cat) => cat.type == 'TEMPLATE').toList();

      state = state.copyWith(
        categories: categories,
        locationCategories: locationCategories,
        templateCategories: templateCategories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadCategories();
  }
}
