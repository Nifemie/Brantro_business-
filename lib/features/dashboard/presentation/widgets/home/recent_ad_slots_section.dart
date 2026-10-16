import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';
import '../../../../ad_slot/logic/ad_slot_provider.dart';
import '../../../../ad_slot/presentation/widgets/ad_slot_item_card.dart';
import '../../../../../core/widgets/empty_state.dart';

class RecentAdSlotsSection extends ConsumerWidget {
  const RecentAdSlotsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final adSlotsState = ref.watch(adSlotProvider);
    final sortedData = List.of(adSlotsState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentAdSlots = sortedData.take(3).toList();

    if (recentAdSlots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Ad Slots',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/ad-slots');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Column(
                children: recentAdSlots.map((adSlot) {
                  return AdSlotItemCard(
                    slot: adSlot,
                    onEdit: () {
                      context.push('/create-ad-slot', extra: {
                        'parentId': adSlot.parentId,
                        'parentType': adSlot.parentType,
                        'parentName': adSlot.title ?? adSlot.slotNumber,
                        'isUpdate': true,
                        'existingSlot': adSlot,
                      });
                    },
                    onDelete: () async {
                      final confirm = await _showDeleteConfirmation(context, adSlot.slotNumber);
                      if (confirm == true) {
                        try {
                          await ref.read(adSlotProvider.notifier).deleteSlot(adSlot.id);
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
                }).toList(),
              ),
      ],
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
