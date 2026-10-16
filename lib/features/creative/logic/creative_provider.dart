import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/repositories/creative_repository.dart';
import '../data/models/creative_model.dart';
import 'creative_notifier.dart';

final creativeRepositoryProvider = Provider<CreativeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CreativeRepository(apiClient);
});

final creativeProvider = StateNotifierProvider<CreativeNotifier, DataState<CreativeModel>>((ref) {
  final repository = ref.watch(creativeRepositoryProvider);
  return CreativeNotifier(repository);
});
