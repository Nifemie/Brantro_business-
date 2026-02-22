import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/service_repository.dart';
import '../data/models/service_model.dart';

final serviceRepositoryProvider = Provider((ref) {
  final apiClient = ApiClient();
  return ServiceRepository(apiClient);
});

class ServicesNotifier extends AsyncNotifier<DataState<ServiceModel>> {
  late final ServiceRepository _repository;

  String _getUserFriendlyError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socketexception') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('connection error')) {
      return 'No internet connection. Please check your network.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('401') ||
        errorString.contains('unauthorized')) {
      return 'Session expired. Please log in again.';
    } else if (errorString.contains('404')) {
      return 'Resource not found.';
    } else if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503')) {
      return 'Server error. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<DataState<ServiceModel>> build() async {
    _repository = ref.read(serviceRepositoryProvider);
    final response = await _repository.getServices(page: 0, size: 10);
    log(
      '[ServicesNotifier] Successfully fetched ${response.services.length} services',
    );

    return DataState<ServiceModel>(
      data: response.services,
      isDataAvailable: response.services.isNotEmpty,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      message: response.services.isEmpty ? 'No services available' : null,
    );
  }

  Future<void> fetchServices({int page = 0, int size = 10}) async {
    log('[ServicesNotifier] Fetching services with page=$page, size=$size');
    state = const AsyncLoading();

    try {
      final response = await _repository.getServices(page: page, size: size);
      log(
        '[ServicesNotifier] Successfully fetched ${response.services.length} services',
      );

      state = AsyncData(
        DataState<ServiceModel>(
          data: response.services,
          isDataAvailable: response.services.isNotEmpty,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[ServicesNotifier] Error fetching services: $e\n$stackTrace');
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || current.isPaginating || !current.isDataAvailable) {
      return;
    }

    final nextPage = current.currentPage + 1;
    if (nextPage >= current.totalPages) return;

    log('[ServicesNotifier] Loading more services, page=$nextPage');

    state = AsyncData(current.copyWith(isPaginating: true, message: null));

    try {
      final response = await _repository.getServices(page: nextPage, size: 10);
      log(
        '[ServicesNotifier] Successfully loaded ${response.services.length} more services',
      );

      state = AsyncData(
        current.copyWith(
          isPaginating: false,
          data: [...(current.data ?? []), ...response.services],
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stack) {
      log('[ServicesNotifier] Error loading more services: $e\n$stack');
      state = AsyncData(
        current.copyWith(
          isPaginating: false,
          message: _getUserFriendlyError(e),
        ),
      );
    }
  }

  Future<void> searchServices({required String query}) async {
    if (query.isEmpty) {
      await fetchServices();
      return;
    }

    log('[ServicesNotifier] Searching services with query: $query');

    state = const AsyncLoading();

    try {
      final response = await _repository.searchServices(
        query: query,
        page: 0,
        size: 10,
      );
      log(
        '[ServicesNotifier] Successfully found ${response.services.length} services',
      );

      state = AsyncData(
        DataState<ServiceModel>(
          data: response.services,
          isDataAvailable: response.services.isNotEmpty,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stack) {
      log('[ServicesNotifier] Error searching services: $e\n$stack');
      state = AsyncError(e, stack);
    }
  }

  void clearMessage() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(message: null));
  }

  void reset() {
    state = AsyncData(DataState.initial());
  }
}

final servicesProvider =
    AsyncNotifierProvider<ServicesNotifier, DataState<ServiceModel>>(
      ServicesNotifier.new,
    );
