import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/billboard_model.dart';

class BillboardState {
  final List<BillboardModel> billboards;
  final bool isLoading;
  final String? error;

  BillboardState({
    this.billboards = const [],
    this.isLoading = false,
    this.error,
  });

  BillboardState copyWith({
    List<BillboardModel>? billboards,
    bool? isLoading,
    String? error,
  }) {
    return BillboardState(
      billboards: billboards ?? this.billboards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BillboardNotifier extends StateNotifier<BillboardState> {
  BillboardNotifier() : super(BillboardState()) {
    _loadMockData();
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

    state = state.copyWith(billboards: mockBillboards);
  }

  Future<void> uploadBillboard(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final newBillboard = BillboardModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: data['title'] ?? '',
        location: data['state'] ?? '',
        address: '${data['address']}, ${data['city']}, ${data['state']}',
        size: data['features'] ?? '',
        type: data['type'] ?? '',
        price: double.tryParse(data['rateAmount'] ?? '0') ?? 0,
        status: 'available',
        images: data['images'] ?? [],
        latitude: double.tryParse(data['latitude'] ?? ''),
        longitude: double.tryParse(data['longitude'] ?? ''),
        isActive: true,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        billboards: [...state.billboards, newBillboard],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteBillboard(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        billboards: state.billboards.where((b) => b.id != id).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshBillboards() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _loadMockData();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final billboardProvider = StateNotifierProvider<BillboardNotifier, BillboardState>((ref) {
  return BillboardNotifier();
});
