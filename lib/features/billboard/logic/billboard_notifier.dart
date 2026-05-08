import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import '../data/repositories/billboard_repository.dart';
import '../data/models/billboard_model.dart';

class BillboardNotifier extends StateNotifier<DataState<BillboardModel>> {
  final BillboardRepository _repository;

  BillboardNotifier(this._repository) : super(DataState.initial()) {
    _loadMockData();
  }



  Future<void> uploadBillboard(Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await _repository.createLocation(data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Billboard uploaded successfully',
      );
      // Reload billboards after upload
      await refreshBillboards();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  void _loadMockData() {
    // Load mock billboards
    final mockBillboards = [
      BillboardModel(
        id: '1',
        name: 'Nyanya Expressway Billboard',
        location: 'FCT',
        address: 'Nyanya Expressway, Gwagwalada, Federal Capital Territory',
        size: '48ft x 14ft',
        type: 'Billboard',
        price: 500000,
        status: 'available',
        images: ['assets/brantro/billboard_nyanya.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
      BillboardModel(
        id: '2',
        name: 'Wuse Zone 5 Billboard',
        location: 'FCT',
        address: 'Wuse Zone 5, Abuja, Federal Capital Territory',
        size: '40ft x 20ft',
        type: 'Billboard',
        price: 750000,
        status: 'available',
        images: ['assets/brantro/billboard_wuse.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
      BillboardModel(
        id: '3',
        name: 'Wuse Market Billboard',
        location: 'FCT',
        address: 'Wuse Market, Abuja, Federal Capital Territory',
        size: '36ft x 12ft',
        type: 'Billboard',
        price: 450000,
        status: 'available',
        images: ['assets/brantro/billboard_wuse_constrix.png'],
        isActive: false,
        createdAt: DateTime.now(),
      ),
    ];

    state = state.copyWith(
      data: mockBillboards,
      isDataAvailable: true,
    );
  }

  Future<void> deleteBillboard(String id) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedList = state.data?.where((b) => b.id != id).toList() ?? [];
      state = state.copyWith(
        data: updatedList,
        isInitialLoading: false,
        message: 'Billboard deleted successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshBillboards() async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      // TODO: Replace with actual API call to fetch billboards
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

  Future<void> fetchBillboards({
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

      // TODO: Parse response and update state
      // For now using mock data
      _loadMockData();
      
      state = state.copyWith(
        isInitialLoading: false,
        isPaginating: false,
        currentPage: page,
        // totalPages: response['totalPages'],
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
