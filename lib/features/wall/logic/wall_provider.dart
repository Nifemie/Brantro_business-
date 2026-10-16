import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/repositories/wall_repository.dart';
import '../data/models/wall_model.dart';
import 'wall_notifier.dart';

final wallRepositoryProvider = Provider<WallRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WallRepository(apiClient);
});

final wallProvider = StateNotifierProvider<WallNotifier, DataState<WallModel>>((ref) {
  final repository = ref.watch(wallRepositoryProvider);
  return WallNotifier(repository);
});
