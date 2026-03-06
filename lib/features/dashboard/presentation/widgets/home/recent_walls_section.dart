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
    final recentWalls = wallsState.walls.take(3).toList();

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
        recentWalls.isEmpty
            ? EmptyState(
                icon: Icons.wallpaper_outlined,
                title: 'No Walls Yet',
                message: 'Your ad walls will appear here',
                showIconBackground: false,
              )
            : Column(
                children: recentWalls.map((wall) {
                  return WallCard(
                    image: wall.images.isNotEmpty ? wall.images.first : '',
                    name: wall.name,
                    location: wall.location,
                    size: wall.size,
                    price: '₦${wall.price.toStringAsFixed(0)}',
                    isActive: wall.isActive,
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
