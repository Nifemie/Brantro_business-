import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/ad_placement_repository.dart';
import 'ad_placement_notifier.dart';
export 'ad_placement_notifier.dart';

final adPlacementProvider = StateNotifierProvider.family<AdPlacementNotifier, AdPlacementState, String>((ref, campaignOrderId) {
  final repository = ref.watch(adPlacementRepositoryProvider);
  return AdPlacementNotifier(repository, campaignOrderId);
});

final adProofsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, placementId) async {
  final repository = ref.watch(adPlacementRepositoryProvider);
  return await repository.getProofs(placementId);
});
