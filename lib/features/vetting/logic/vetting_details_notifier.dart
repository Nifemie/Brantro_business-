import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/models/vetting_model.dart';
import '../data/vetting_service.dart';

class VettingDetailsNotifier extends StateNotifier<DataState<VettingOptionModel>> {
  final VettingRepository _repository;

  VettingDetailsNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchVettingDetails(String id, {VettingOptionModel? initialData}) async {
    if (initialData != null) {
      state = state.copyWith(
        isDataAvailable: true,
        singleData: initialData,
        isInitialLoading: true,
      );
    } else {
      state = state.copyWith(isInitialLoading: true);
    }

    try {
      final vetting = await _repository.getVettingById(id);
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        singleData: vetting,
        message: null,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: state.singleData != null,
        message: e.toString(),
      );
    }
  }
}

final vettingRepositoryProvider = Provider<VettingRepository>((ref) {
  final apiClient = ApiClient();
  return VettingRepository(apiClient);
});

final vettingDetailsProvider = StateNotifierProvider.family<
    VettingDetailsNotifier, DataState<VettingOptionModel>, String>((ref, id) {
  final repository = ref.watch(vettingRepositoryProvider);
  return VettingDetailsNotifier(repository);
});
