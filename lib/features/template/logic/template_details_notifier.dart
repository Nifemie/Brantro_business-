import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../data/models/template_model.dart';
import '../data/template_service.dart';
import 'template_notifier.dart'; // To access templateRepositoryProvider

class TemplateDetailsNotifier extends StateNotifier<DataState<TemplateModel>> {
  final TemplateRepository _repository;

  TemplateDetailsNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchTemplateDetails(String id, {TemplateModel? initialData}) async {
    // If we have initial data (e.g. from list), show it immediately
    if (initialData != null) {
      state = state.copyWith(
        isDataAvailable: true,
        singleData: initialData,
        isInitialLoading: true, // Still loading fresh data
      );
    } else {
      state = state.copyWith(isInitialLoading: true);
    }

    try {
      final template = await _repository.getTemplateById(id);
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        singleData: template,
        message: null,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        // Keep showing stale data if we have it, just show error message
        isDataAvailable: state.singleData != null,
        message: e.toString(),
      );
    }
  }
}

final templateDetailsProvider = StateNotifierProvider.family<
    TemplateDetailsNotifier, DataState<TemplateModel>, String>((ref, id) {
  final repository = ref.watch(templateRepositoryProvider);
  return TemplateDetailsNotifier(repository);
});
