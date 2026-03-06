import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../logic/ad_slot_provider.dart';
import '../widgets/ad_slot_item_card.dart';

class AdSlotScreen extends ConsumerStatefulWidget {
  final String parentId;
  final String parentType; // 'billboard', 'wall', 'screen'
  final String parentName;

  const AdSlotScreen({
    super.key,
    required this.parentId,
    required this.parentType,
    required this.parentName,
  });

  @override
  ConsumerState<AdSlotScreen> createState() => _AdSlotScreenState();
}

class _AdSlotScreenState extends ConsumerState<AdSlotScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adSlotProvider.notifier).fetchSlots(widget.parentId, widget.parentType);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _typeLabel {
    switch (widget.parentType.toLowerCase()) {
      case 'billboard':
        return 'Billboard';
      case 'wall':
        return 'Wall';
      case 'screen':
        return 'Screen';
      default:
        return 'Ad';
    }
  }

  String get _screenTitle {
    switch (widget.parentType.toLowerCase()) {
      case 'billboard':
        return 'BILLBOARD AD SLOTS';
      case 'wall':
        return 'WALL AD SLOTS';
      case 'screen':
        return 'SCREEN AD SLOTS';
      default:
        return 'AD SLOTS';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adSlotState = ref.watch(adSlotProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            DashboardAppBar(title: _screenTitle),
            
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Search and Create Slot Section as Sliver
                  SliverToBoxAdapter(
                    child: SearchFilterCard(
                      title: 'Ad Slots',
                      searchController: _searchController,
                      searchHint: 'Search slots...',
                      showFilterButton: false,
                      actionButtonLabel: 'Create Slot',
                      actionButtonIcon: Icons.add,
                      onActionButtonTap: () {
                        context.push('/create-ad-slot', extra: {
                          'parentId': widget.parentId,
                          'parentType': widget.parentType,
                          'parentName': widget.parentName,
                        });
                      },
                    ),
                  ),
                  
                  // Parent Name
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.parentName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.brightness == Brightness.dark 
                                ? Colors.grey[400] 
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                  
                  // Slots List
                  adSlotState.isLoading
                      ? SliverFillRemaining(
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      : adSlotState.slots.isEmpty
                          ? SliverFillRemaining(
                              child: EmptyState(
                                icon: Icons.layers_outlined,
                                title: 'No Slots Yet',
                                message: 'Create slots to start managing bookings for this $_typeLabel',
                                showIconBackground: false,
                              ),
                            )
                          : SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final slot = adSlotState.slots[index];
                                    return AdSlotItemCard(
                                      slot: slot,
                                      onEdit: () {
                                        print('Edit slot ${slot.slotNumber}');
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
                                  childCount: adSlotState.slots.length,
                                ),
                              ),
                            ),
                ],
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
