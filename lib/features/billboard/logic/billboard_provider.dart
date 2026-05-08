import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/network/api_client.dart';
import 'package:brantro_business/core/data/data_state.dart';
import '../data/repositories/billboard_repository.dart';
import '../data/models/billboard_model.dart';
import 'billboard_notifier.dart';

final billboardRepositoryProvider = Provider<BillboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BillboardRepository(apiClient);
});

final billboardProvider = StateNotifierProvider<BillboardNotifier, DataState<BillboardModel>>((ref) {
  final repository = ref.watch(billboardRepositoryProvider);
  return BillboardNotifier(repository);
});
