import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/repositories/service_repository.dart';
import '../data/models/service_model.dart';
import 'service_notifier.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ServiceRepository(apiClient);
});

final serviceProvider = StateNotifierProvider<ServiceNotifier, DataState<ServiceModel>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return ServiceNotifier(repository);
});
