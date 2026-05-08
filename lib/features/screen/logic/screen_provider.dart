import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/repositories/screen_repository.dart';
import '../data/models/screen_model.dart';
import 'screen_notifier.dart';

final screenRepositoryProvider = Provider<ScreenRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ScreenRepository(apiClient);
});

final screenProvider = StateNotifierProvider<ScreenNotifier, DataState<ScreenModel>>((ref) {
  final repository = ref.watch(screenRepositoryProvider);
  return ScreenNotifier(repository);
});
