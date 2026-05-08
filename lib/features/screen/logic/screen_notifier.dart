import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import '../data/repositories/screen_repository.dart';
import '../data/models/screen_model.dart';

class ScreenNotifier extends StateNotifier<DataState<ScreenModel>> {
  final ScreenRepository _repository;

  ScreenNotifier(this._repository) : super(DataState.initial()) {
    _loadMockData();
  }

  // Expose repository for file uploads
  ScreenRepository get repository => _repository;

  Future<void> uploadScreen(Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await _repository.createLocation(data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Screen uploaded successfully',
      );
      await refreshScreens();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  void _loadMockData() {
    final mockScreens = [
      ScreenModel(
        id: '1',
        name: 'Transcorp Hilton Digital Screen',
        location: 'FCT',
        address: 'Transcorp Hilton Hotel, Abuja, Federal Capital Territory',
        size: '55 inch LED',
        type: 'Digital Screen',
        price: 450000,
        status: 'available',
        images: ['assets/brantro/screensy-05.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
      ScreenModel(
        id: '2',
        name: 'Shoprite Digital Display',
        location: 'FCT',
        address: 'Shoprite Mall, Abuja, Federal Capital Territory',
        size: '65 inch LED',
        type: 'Digital Screen',
        price: 380000,
        status: 'available',
        images: ['assets/brantro/screensy-06.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
      ScreenModel(
        id: '3',
        name: 'Airport Terminal Screen',
        location: 'FCT',
        address: 'Nnamdi Azikiwe Airport, Abuja, Federal Capital Territory',
        size: '75 inch LED',
        type: 'Digital Screen',
        price: 600000,
        status: 'available',
        images: ['assets/brantro/screensy-07.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
    ];

    state = state.copyWith(
      data: mockScreens,
      isDataAvailable: true,
    );
  }

  Future<void> deleteScreen(String id) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await Future.delayed(const Duration(seconds: 1));

      final updatedList = state.data?.where((s) => s.id != id).toList() ?? [];
      state = state.copyWith(
        data: updatedList,
        isInitialLoading: false,
        message: 'Screen deleted successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshScreens() async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await Future.delayed(const Duration(seconds: 1));
      _loadMockData();
      state = state.copyWith(isInitialLoading: false);
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
    }
  }

  Future<void> fetchScreens({
    int page = 0,
    int size = 20,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(isInitialLoading: true, message: null);
    } else if (state.isPaginating) {
      return;
    } else {
      state = state.copyWith(isPaginating: true);
    }

    try {
      final response = await _repository.getLocations(
        page: page,
        size: size,
      );

      _loadMockData();
      
      state = state.copyWith(
        isInitialLoading: false,
        isPaginating: false,
        currentPage: page,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        isPaginating: false,
        message: e.toString(),
      );
    }
  }
}
