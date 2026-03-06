import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/screen_model.dart';

class ScreenState {
  final List<ScreenModel> screens;
  final bool isLoading;
  final String? error;

  ScreenState({
    this.screens = const [],
    this.isLoading = false,
    this.error,
  });

  ScreenState copyWith({
    List<ScreenModel>? screens,
    bool? isLoading,
    String? error,
  }) {
    return ScreenState(
      screens: screens ?? this.screens,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ScreenNotifier extends StateNotifier<ScreenState> {
  ScreenNotifier() : super(ScreenState()) {
    _loadMockData();
  }

  void _loadMockData() {
    // Load mock screens
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

    state = state.copyWith(screens: mockScreens);
  }

  Future<void> uploadScreen(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final newScreen = ScreenModel(
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
        screens: [...state.screens, newScreen],
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

  Future<void> deleteScreen(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        screens: state.screens.where((s) => s.id != id).toList(),
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

  Future<void> refreshScreens() async {
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

final screenProvider = StateNotifierProvider<ScreenNotifier, ScreenState>((ref) {
  return ScreenNotifier();
});
