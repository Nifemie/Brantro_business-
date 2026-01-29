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

class ServicesNotifier extends StateNotifier<DataState<ServiceModel>> {
  final ServiceRepository _repository;

  ServicesNotifier(this._repository) : super(DataState.initial());

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

  Future<void> fetchServices({int page = 0, int size = 10}) async {
    log('[ServicesNotifier] Fetching services with page=$page, size=$size');

    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getServices(page: page, size: size);
      log('[ServicesNotifier] Successfully fetched ${response.services.length} services');

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.services,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[ServicesNotifier] Error fetching services: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: _getUserFriendlyError(e),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isPaginating || !state.isDataAvailable) return;

    final nextPage = state.currentPage + 1;
    if (nextPage >= state.totalPages) return;

    log('[ServicesNotifier] Loading more services, page=$nextPage');

    state = state.copyWith(isPaginating: true, message: null);

    try {
      final response = await _repository.getServices(
        page: nextPage,
        size: 10,
      );
      log('[ServicesNotifier] Successfully loaded ${response.services.length} more services');

      state = state.copyWith(
        isPaginating: false,
        data: [...(state.data ?? []), ...response.services],
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[ServicesNotifier] Error loading more services: $e\n$stack');
      state = state.copyWith(
        isPaginating: false,
        message: _getUserFriendlyError(e),
      );
    }
  }

  Future<void> searchServices({required String query}) async {
    if (query.isEmpty) {
      await fetchServices();
      return;
    }

    log('[ServicesNotifier] Searching services with query: $query');

    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.searchServices(
        query: query,
        page: 0,
        size: 10,
      );
      log('[ServicesNotifier] Successfully found ${response.services.length} services');

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.services,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[ServicesNotifier] Error searching services: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: _getUserFriendlyError(e),
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  void reset() {
    state = DataState.initial();
  }
}

final servicesProvider =
    StateNotifierProvider<ServicesNotifier, DataState<ServiceModel>>(
  (ref) {
    final repository = ref.watch(serviceRepositoryProvider);
    return ServicesNotifier(repository);
  },
);
