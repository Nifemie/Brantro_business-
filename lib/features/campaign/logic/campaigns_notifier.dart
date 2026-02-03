import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/campaign_repository.dart';
import '../data/models/campaign_model.dart';

final campaignRepositoryProvider = Provider((ref) {
  final apiClient = ApiClient();
  return CampaignRepository(apiClient);
});

class CampaignsState {
  final List<CampaignModel> campaigns;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  CampaignsState({
    this.campaigns = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasMore = true,
  });

  CampaignsState copyWith({
    List<CampaignModel>? campaigns,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return CampaignsState(
      campaigns: campaigns ?? this.campaigns,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CampaignsNotifier extends StateNotifier<CampaignsState> {
  final CampaignRepository _repository;
  String? _currentStatus;

  CampaignsNotifier(this._repository) : super(CampaignsState());

  Future<void> fetchCampaigns({
    String? status,
    int page = 0,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = CampaignsState(isLoading: true);
      _currentStatus = status;
    } else if (state.isLoading || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final response = await _repository.getMyCampaigns(
        page: page,
        size: 10,
        status: status,
      );

      if (response.payload != null) {
        final newCampaigns = response.payload!.page;
        final totalPages = response.payload!.totalPages;
        final currentPage = response.payload!.currentPage;

        // Combine and sort campaigns - cancelled ones go to bottom
        final allCampaigns = refresh ? newCampaigns : [...state.campaigns, ...newCampaigns];
        final sortedCampaigns = _sortCampaigns(allCampaigns);

        state = state.copyWith(
          campaigns: sortedCampaigns,
          isLoading: false,
          error: null,
          currentPage: currentPage,
          totalPages: totalPages,
          hasMore: currentPage < totalPages - 1,
        );
      } else {
        state = state.copyWith(
          campaigns: refresh ? [] : state.campaigns,
          isLoading: false,
          error: null,
          hasMore: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.isLoading && state.hasMore) {
      await fetchCampaigns(
        status: _currentStatus,
        page: state.currentPage + 1,
      );
    }
  }

  Future<void> refresh({String? status}) async {
    await fetchCampaigns(status: status, refresh: true);
  }

  Future<Map<String, dynamic>> cancelCampaign(int campaignId) async {
    try {
      final result = await _repository.cancelCampaign(campaignId);
      
      // Refresh the campaigns list after successful cancellation
      await refresh(status: _currentStatus);
      
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sort campaigns: Active statuses first, cancelled/completed last
  List<CampaignModel> _sortCampaigns(List<CampaignModel> campaigns) {
    final sorted = List<CampaignModel>.from(campaigns);
    
    sorted.sort((a, b) {
      // Define priority order (lower number = higher priority)
      final priorityA = _getStatusPriority(a.status);
      final priorityB = _getStatusPriority(b.status);
      
      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }
      
      // If same priority, sort by date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return sorted;
  }

  int _getStatusPriority(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 1;
      case 'ACCEPTED':
        return 2;
      case 'IN_PROGRESS':
      case 'ACTIVE':
        return 3;
      case 'PAUSED':
        return 4;
      case 'COMPLETED':
        return 5;
      case 'CANCELLED':
        return 6;
      default:
        return 7;
    }
  }
}

final campaignsProvider = StateNotifierProvider<CampaignsNotifier, CampaignsState>(
  (ref) {
    final repository = ref.watch(campaignRepositoryProvider);
    return CampaignsNotifier(repository);
  },
);
