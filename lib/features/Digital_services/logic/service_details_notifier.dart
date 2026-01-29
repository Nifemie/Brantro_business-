import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/data_state.dart';
import '../data/models/service_model.dart';
import '../data/service_repository.dart';
import 'services_notifier.dart'; // To access serviceRepositoryProvider

class ServiceDetailsNotifier extends StateNotifier<DataState<ServiceModel>> {
  final ServiceRepository _repository;

  ServiceDetailsNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchServiceDetails(String id, {ServiceModel? initialData}) async {
    // If we have initial data (e.g. from list), show it immediately
    if (initialData != null) {
      state = state.copyWith(
        isDataAvailable: true,
        singleData: initialData, // Use singleData
        isInitialLoading: true, // Still loading fresh data
      );
    } else {
      state = state.copyWith(isInitialLoading: true);
    }

    try {
      final service = await _repository.getServiceById(id);
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        singleData: service, // Use singleData
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

final serviceDetailsProvider = StateNotifierProvider.family<
    ServiceDetailsNotifier, DataState<ServiceModel>, String>((ref, id) {
  final repository = ref.watch(serviceRepositoryProvider);
  return ServiceDetailsNotifier(repository);
});
