import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/models/vehicle_model.dart';
import 'vehicle_notifier.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VehicleRepository(apiClient);
});

final vehicleProvider = StateNotifierProvider<VehicleNotifier, DataState<VehicleModel>>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return VehicleNotifier(repository);
});
