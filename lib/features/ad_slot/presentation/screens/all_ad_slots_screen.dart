import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../logic/ad_slot_provider.dart';
import '../widgets/ad_slot_item_card.dart';
import '../widgets/ad_slot_search_filter_card.dart';

class AllAdSlotsScreen extends ConsumerStatefulWidget {
  const AllAdSlotsScreen({super.key});

  @override
  ConsumerState<AllAdSlotsScreen> createState() => _AllAdSlotsScreenState();
}

class _AllAdSlotsScreenState extends ConsumerState<AllAdSlotsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch some general mock slots for demonstration
      ref.read(adSlotProvider.notifier).fetchSlots('all', 'general');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adSlotState = ref.watch(adSlotProvider);
    final adSlotNotifier = ref.read(adSlotProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'ALL AD SLOTS'),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(adSlotProvider.notifier).fetchSlots('all', 'general');
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: AdSlotSearchFilterCard(
                        title: 'All Advertisement Slots',
                        searchController: _searchController,
                        selectedPlatform: adSlotNotifier.selectedPlatform,
                        selectedPartnerType: adSlotNotifier.selectedPartnerType,
                        onSearchChanged: (query) => adSlotNotifier.updateSearch(query),
                        onPlatformSelected: (platform) => adSlotNotifier.updatePlatform(platform),
                        onPartnerTypeSelected: (partnerType) => adSlotNotifier.updatePartnerType(partnerType),
                        onCreateSlotTap: () {
                          context.push('/create-ad-slot', extra: {
                            'parentId': 'all',
                            'parentType': 'general',
                            'parentName': 'General Ad Slot',
                          });
                        },
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                    adSlotState.isInitialLoading
                        ? SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => const SkeletonAdSlotCard(),
                                childCount: 3,
                              ),
                            ),
                          )
                        : adSlotState.message != null
                            ? SliverFillRemaining(
                                child: Builder(
                                  builder: (context) {
                                    final rawMsg = adSlotState.message!;
                                    final msg = rawMsg
                                        .replaceAll(RegExp(r'Exception:\s*'), '')
                                        .replaceAll(RegExp(r'Failed to fetch ad slots:\s*'), '')
                                        .trim();
                                    final isNetworkError = msg.contains('SocketException') || msg.contains('Failed host lookup') || msg.contains('Network error');
                                    
                                    return EmptyState(
                                      icon: isNetworkError ? Icons.wifi_off_outlined : Icons.inbox_outlined,
                                      title: isNetworkError ? 'Connection Error' : 'Notice',
                                      message: isNetworkError ? 'Failed to load ad slots. Please check your internet connection and try again.' : msg,
                                      showIconBackground: isNetworkError,
                                    );
                                  }
                                ),
                              )
                            : (adSlotState.data ?? []).isEmpty
                                ? const SliverFillRemaining(
                                    child: EmptyState(
                                      icon: Icons.layers_outlined,
                                      title: 'No Slots Found',
                                      message: 'Click "Create Slot" to add a new slot to the platform.',
                                      showIconBackground: false,
                                    ),
                                  )
                            : SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final slot = (adSlotState.data ?? [])[index];
                                      return AdSlotItemCard(
                                        slot: slot,
                                        onEdit: () {
                                          context.push('/create-ad-slot', extra: {
                                            'parentId': slot.parentId,
                                            'parentType': slot.parentType,
                                            'parentName': slot.title ?? slot.slotNumber,
                                            'isUpdate': true,
                                            'existingSlot': slot,
                                          });
                                        },
                                        onDelete: () async {
                                          final confirm = await _showDeleteConfirmation(context, slot.slotNumber);
                                          if (confirm == true) {
                                            try {
                                              await ref.read(adSlotProvider.notifier).deleteSlot(slot.id);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Slot deleted successfully'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Delete failed: ${e.toString()}'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                      );
                                    },
                                    childCount: (adSlotState.data ?? []).length,
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String slotNumber) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Slot'),
        content: Text('Are you sure you want to delete "$slotNumber"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
