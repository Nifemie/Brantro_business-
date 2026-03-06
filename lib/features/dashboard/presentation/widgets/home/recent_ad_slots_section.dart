import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final recentAdSlots = adSlotsState.slots.take(3).toList();

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
        recentAdSlots.isEmpty
            ? EmptyState(
                icon: Icons.layers_outlined,
                title: 'No Ad Slots Yet',
                message: 'Your ad slots will appear here',
                showIconBackground: false,
              )
            : Column(
                children: recentAdSlots.map((adSlot) {
                  return AdSlotItemCard(
                    slot: adSlot,
                    onEdit: () {
                      // TODO: Navigate to edit ad slot
                    },
                    onDelete: () {
                      // TODO: Delete ad slot
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }
}
