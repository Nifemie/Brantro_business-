import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../widgets/ad_placement_card.dart';
import '../../features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/search_filter_card.dart';
import '../widgets/empty_state.dart';
import '../../features/ad_slot/logic/ad_placement_provider.dart';
import 'ad_placement_details_screen.dart';
import '../widgets/ad_placement_details/upload_proof_dialog.dart';

class AdPlacementScreen extends ConsumerStatefulWidget {
  final String campaignId;

  const AdPlacementScreen({
    super.key,
    required this.campaignId,
  });

  @override
  ConsumerState<AdPlacementScreen> createState() => _AdPlacementScreenState();
}

class _AdPlacementScreenState extends ConsumerState<AdPlacementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  final List<String> _filters = [
    'All',
    'Pending',
    'Accepted',
    'In Progress',
    'Completed',
    'Rejected',
    'Cancelled'
  ];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(adPlacementProvider(widget.campaignId).notifier).search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final placementState = ref.watch(adPlacementProvider(widget.campaignId));
    final allPlacements = placementState.data ?? [];
    
    // Filter placements based on selected tab
    final placements = allPlacements.where((p) {
      if (_selectedFilter == 'All') return true;
      
      final statusLower = p.status.trim().toLowerCase();
      switch (_selectedFilter) {
        case 'Pending':
          return statusLower == 'pending' || statusLower == 'requested';
        case 'Accepted':
          return statusLower == 'accepted' || statusLower == 'approved';
        case 'In Progress':
          return statusLower == 'in_progress' || statusLower == 'in progress' || statusLower == 'inprogress';
        case 'Completed':
          return statusLower == 'completed';
        case 'Rejected':
          return statusLower == 'rejected';
        case 'Cancelled':
          return statusLower == 'cancelled';
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'AD PLACEMENTS'),
            Expanded(
              child: placementState.isInitialLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => ref.read(adPlacementProvider(widget.campaignId).notifier).refresh(),
                      child: CustomScrollView(
                        slivers: [
                                // Search Filter Card
                              SliverToBoxAdapter(
                                child: SearchFilterCard(
                                  title: 'All Placements',
                                  searchController: _searchController,
                                  searchHint: 'Search placements...',
                                  showFilterButton: true,
                                  showActionButton: false,
                                  onFilterTap: () {
                                    // TODO: Show filter sheet
                                  },
                                ),
                              ),
                              
                              // Filter Tabs
                              SliverToBoxAdapter(
                                child: Container(
                                  height: 50.h,
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    itemCount: _filters.length,
                                    itemBuilder: (context, index) {
                                      final filter = _filters[index];
                                      final isSelected = filter == _selectedFilter;
                                      
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: ChoiceChip(
                                          label: Text(
                                            filter,
                                            style: TextStyle(
                                              color: isSelected 
                                                ? Colors.white 
                                                : (isDark ? Colors.grey[300] : Colors.grey[700]),
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                _selectedFilter = filter;
                                              });
                                            }
                                          },
                                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                          selectedColor: const Color(0xFFFF7A45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.r),
                                            side: BorderSide(
                                              color: isSelected ? Colors.transparent : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              
                              // Placement List
                              if (placements.isEmpty)
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: const EmptyState(
                                    icon: Icons.movie_creation_outlined,
                                    title: 'No Placements',
                                    message: 'No ad placements found for this filter.',
                                    showIconBackground: false,
                                  ),
                                )
                              else
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final placement = placements[index];
                                      
                                      return AdPlacementCard(
                                        placementId: placement.id.toString(),
                                        description: placement.description,
                                        advertiserName: placement.advertiserName,
                                        advertiserEmail: placement.advertiserEmail,
                                        platforms: placement.platforms.isNotEmpty ? placement.platforms.join(', ') : 'None',
                                        contentTypes: placement.contentTypes.isNotEmpty ? placement.contentTypes.join(', ') : 'None',
                                        amount: placement.amount,
                                        date: DateFormat('M/d/yyyy').format(placement.createdAt),
                                        status: placement.status,
                                        hasApprovedProof: placement.hasApprovedProof,
                                        onMenuTap: () {
                                          // TODO: Handle menu tap
                                        },
                                        onAcceptTap: () async {
                                          final confirm = await _showAcceptConfirmation(context);
                                          if (confirm == true) {
                                            try {
                                              await ref.read(adPlacementProvider(widget.campaignId).notifier).acceptPlacement(placement.id);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Placement accepted successfully'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Failed to accept: ${e.toString()}'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        onRejectTap: () async {
                                          final reason = await _showRejectDialog(context);
                                          if (reason != null && reason.isNotEmpty) {
                                            try {
                                              await ref.read(adPlacementProvider(widget.campaignId).notifier).rejectPlacement(placement.id, reason);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Placement rejected successfully'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Failed to reject: ${e.toString()}'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        onUploadProof: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => UploadProofDialog(
                                              placementId: placement.id,
                                              campaignId: widget.campaignId,
                                            ),
                                          );
                                        },
                                        onMarkInProgress: () async {
                                          try {
                                            await ref.read(adPlacementProvider(widget.campaignId).notifier).inProgressPlacement(placement.id);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Placement marked as in progress'), backgroundColor: Colors.blue),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Failed: ${e.toString()}'), backgroundColor: Colors.red),
                                              );
                                            }
                                          }
                                        },
                                        onMarkCompleted: () async {
                                          try {
                                            await ref.read(adPlacementProvider(widget.campaignId).notifier).completePlacement(placement.id);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Placement marked as completed'), backgroundColor: Colors.green),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Failed: ${e.toString()}'), backgroundColor: Colors.red),
                                              );
                                            }
                                          }
                                        },
                                        onCancelTap: () async {
                                          final reason = await _showRejectDialog(context);
                                          if (reason != null && reason.isNotEmpty) {
                                            try {
                                              await ref.read(adPlacementProvider(widget.campaignId).notifier).cancelPlacement(placement.id, reason);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Placement cancelled'), backgroundColor: Colors.red),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Failed to cancel: ${e.toString()}'), backgroundColor: Colors.red),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        onViewTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdPlacementDetailsScreen(placement: placement),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    childCount: placements.length,
                                  ),
                                ),
                              ),
                              if (placementState.isLoading)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                ),
                              
                              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showAcceptConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ACCEPT Placement?'),
        content: const Text('Are you sure you want to accept this ad placement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFF7A45),
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showRejectDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Placement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please provide a reason for rejecting this placement:'),
            SizedBox(height: 16.h),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: 'e.g. not solid',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, reasonController.text),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}
