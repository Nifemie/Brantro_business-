import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../wall/logic/wall_provider.dart';
import '../../../../wall/presentation/widgets/wall_card.dart';
import '../../../../../core/widgets/empty_state.dart';

class RecentWallsSection extends ConsumerWidget {
  const RecentWallsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final wallsState = ref.watch(wallProvider);
    final sortedData = List.of(wallsState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentWalls = sortedData.take(3).toList();

    if (recentWalls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Ad Walls',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/wall-marketplace');
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
                children: recentWalls.map<Widget>((wall) {
                  return WallCard(
                    wall: wall,
                    onViewSlots: () {
                      context.push('/ad-slots', extra: {
                        'parentId': wall.id,
                        'parentType': 'wall',
                        'parentName': wall.name,
                      });
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }
}
