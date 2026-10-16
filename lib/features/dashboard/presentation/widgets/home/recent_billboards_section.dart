import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../billboard/logic/billboard_provider.dart';
import '../../../../billboard/presentation/widgets/billboard_card.dart';
import '../../../../../core/widgets/empty_state.dart';

class RecentBillboardsSection extends ConsumerWidget {
  const RecentBillboardsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final billboardsState = ref.watch(billboardProvider);
    final sortedData = List.of(billboardsState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentBillboards = sortedData.take(3).toList();

    if (recentBillboards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Billboards',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/billboard-marketplace');
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
                children: recentBillboards.map<Widget>((billboard) {
                  return BillboardCard(
                    billboard: billboard,
                    onViewSlots: () {
                      context.push('/ad-slots', extra: {
                        'parentId': billboard.id,
                        'parentType': 'billboard',
                        'parentName': billboard.name,
                      });
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }
}
