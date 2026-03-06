import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/wall_model.dart';

class WallState {
  final List<WallModel> walls;
  final bool isLoading;
  final String? error;

  WallState({
    this.walls = const [],
    this.isLoading = false,
    this.error,
  });

  WallState copyWith({
    List<WallModel>? walls,
    bool? isLoading,
    String? error,
  }) {
    return WallState(
      walls: walls ?? this.walls,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WallNotifier extends StateNotifier<WallState> {
  WallNotifier() : super(WallState()) {
    _loadMockData();
  }

  void _loadMockData() {
    // Load mock walls
    final mockWalls = [
      WallModel(
        id: '1',
        name: 'Jabi Lake Mall Wall',
        location: 'FCT',
        address: 'Jabi Lake Mall, Abuja, Federal Capital Territory',
        size: '30ft x 15ft',
        type: 'Wall',
        price: 350000,
        status: 'available',
        images: ['assets/brantro/screensy-02.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
      WallModel(
        id: '2',
        name: 'Silverbird Cinemas Wall',
        location: 'FCT',
        address: 'Silverbird Cinemas, Abuja, Federal Capital Territory',
        size: '25ft x 12ft',
        type: 'Wall',
        price: 280000,
        status: 'available',
        images: ['assets/brantro/screensy-03.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
      WallModel(
        id: '3',
        name: 'Ceddi Plaza Wall',
        location: 'FCT',
        address: 'Ceddi Plaza, Abuja, Federal Capital Territory',
        size: '20ft x 10ft',
        type: 'Wall',
        price: 200000,
        status: 'available',
        images: ['assets/brantro/screensy-04.png'],
        isActive: true,
        createdAt: DateTime.now(),
      ),
    ];

    state = state.copyWith(walls: mockWalls);
  }

  Future<void> uploadWall(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final newWall = WallModel(
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
        walls: [...state.walls, newWall],
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

  Future<void> deleteWall(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        walls: state.walls.where((w) => w.id != id).toList(),
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

  Future<void> refreshWalls() async {
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

final wallProvider = StateNotifierProvider<WallNotifier, WallState>((ref) {
  return WallNotifier();
});
