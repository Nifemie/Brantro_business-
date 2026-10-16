import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/data_state.dart';
import '../../../../core/network/api_client.dart';
import '../data/models/ad_slot_model.dart';
import '../data/repositories/ad_slot_repository.dart';
import 'ad_slot_notifier.dart';
export 'ad_slot_notifier.dart';

final adSlotRepositoryProvider = Provider<AdSlotRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdSlotRepository(apiClient);
});

final adSlotProvider = StateNotifierProvider<AdSlotNotifier, DataState<AdSlotModel>>((ref) {
  final repository = ref.watch(adSlotRepositoryProvider);
  return AdSlotNotifier(repository);
});
