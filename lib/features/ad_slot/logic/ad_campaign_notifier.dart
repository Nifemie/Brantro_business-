import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/data_state.dart';
import '../data/models/ad_campaign_model.dart';
import '../data/repositories/ad_campaign_repository.dart';

final adCampaignProvider = StateNotifierProvider.autoDispose.family<AdCampaignNotifier, DataState<AdCampaignModel>, String?>((ref, adSlotId) {
  final repository = ref.read(adCampaignRepositoryProvider);
  return AdCampaignNotifier(repository, adSlotId: adSlotId);
});

class AdCampaignNotifier extends StateNotifier<DataState<AdCampaignModel>> {
  final AdCampaignRepository _repository;
  final String? adSlotId;

  AdCampaignNotifier(this._repository, {this.adSlotId}) : super(DataState.initial()) {
    _fetchAdCampaigns();
  }

  Future<void> _fetchAdCampaigns() async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final campaigns = await _repository.fetchAdCampaigns(adSlotId: adSlotId);
      
      // Sort by createdAt descending
      campaigns.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      state = state.copyWith(data: campaigns, isInitialLoading: false);
    } catch (e) {
      state = state.copyWith(isInitialLoading: false, message: e.toString());
    }
  }

  Future<void> refresh() async {
    await _fetchAdCampaigns();
  }

  Future<void> cancelCampaign(String campaignId) async {
    try {
      final updatedCampaign = await _repository.cancelCampaign(campaignId);
      
      if (state.data != null) {
        final currentData = List<AdCampaignModel>.from(state.data!);
        final index = currentData.indexWhere((c) => c.id.toString() == campaignId);
        
        if (index != -1) {
          currentData[index] = updatedCampaign;
          state = state.copyWith(data: currentData);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
