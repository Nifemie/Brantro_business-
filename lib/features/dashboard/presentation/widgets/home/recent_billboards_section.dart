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
    final recentBillboards = billboardsState.data?.take(3).toList() ?? [];

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
        recentBillboards.isEmpty
            ? EmptyState(
                icon: Icons.map_outlined,
                title: 'No Billboards Yet',
                message: 'Your billboards will appear here',
                showIconBackground: false,
              )
            : Column(
                children: recentBillboards.map((billboard) {
                  return BillboardCard(
                    image: billboard.images.isNotEmpty ? billboard.images.first : '',
                    name: billboard.name,
                    location: billboard.location,
                    size: billboard.size,
                    price: '₦${billboard.price.toStringAsFixed(0)}',
                    isActive: billboard.isActive,
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
