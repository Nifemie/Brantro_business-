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
  final apiClient = ref.read(apiClientProvider);
  return TemplateRepository(apiClient);
});

// Provider
final templateProvider =
    AsyncNotifierProvider<TemplateNotifier, DataState<TemplateModel>>(
      TemplateNotifier.new,
    );

// Notifier
class TemplateNotifier extends AsyncNotifier<DataState<TemplateModel>> {
  late final TemplateRepository _repository;

  @override
  Future<DataState<TemplateModel>> build() async {
    _repository = ref.read(templateRepositoryProvider);

    final templates = await _repository.fetchTemplates(page: 0, size: 20);

    return DataState<TemplateModel>(
      data: templates,
      isDataAvailable: templates.isNotEmpty,
      currentPage: 0,
      message: templates.isEmpty ? 'No templates available' : null,
    );
  }

  Future<void> fetchTemplates({int page = 0, int size = 20}) async {
    state = const AsyncLoading();

    try {
      final templates = await _repository.fetchTemplates(
        page: page,
        size: size,
      );

      state = AsyncData(
        DataState<TemplateModel>(
          data: templates,
          isDataAvailable: templates.isNotEmpty,
          currentPage: page,
          message: templates.isEmpty ? 'No templates available' : null,
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void clearError() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(message: null));
  }
}
