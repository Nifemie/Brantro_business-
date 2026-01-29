import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/template_service.dart';
import '../data/models/template_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/data/data_state.dart';

// API Client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Repository provider
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TemplateRepository(apiClient);
});

// Notifier
class TemplateNotifier extends StateNotifier<DataState<TemplateModel>> {
  final TemplateRepository _repository;

  TemplateNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchTemplates({int page = 0, int size = 20}) async {
    // Show initial loading only if no data exists
    if (state.data == null || state.data!.isEmpty) {
      state = state.copyWith(isInitialLoading: true, message: null);
    } else {
      state = state.copyWith(isPaginating: true, message: null);
    }

    try {
      final templates = await _repository.fetchTemplates(
        page: page,
        size: size,
      );

      state = state.copyWith(
        data: templates,
        isPaginating: false,
        isInitialLoading: false,
        isDataAvailable: true,
        currentPage: page,
        message: templates.isEmpty ? 'No templates available' : null,
      );
    } catch (e) {
      state = state.copyWith(
        isPaginating: false,
        isInitialLoading: false,
        message: e.toString(),
        isDataAvailable: state.data != null && state.data!.isNotEmpty,
      );
    }
  }

  void clearError() {
    state = state.copyWith(message: null);
  }
}

// Provider
final templateProvider = StateNotifierProvider<TemplateNotifier, DataState<TemplateModel>>((ref) {
  final repository = ref.watch(templateRepositoryProvider);
  return TemplateNotifier(repository);
});
