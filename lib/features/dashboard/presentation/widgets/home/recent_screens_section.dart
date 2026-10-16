import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../screen/logic/screen_provider.dart';
import '../../../../screen/presentation/widgets/screen_card.dart';
import '../../../../../core/widgets/empty_state.dart';

class RecentScreensSection extends ConsumerWidget {
  const RecentScreensSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screensState = ref.watch(screenProvider);
    final sortedData = List.of(screensState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentScreens = sortedData.take(3).toList();

    if (recentScreens.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Digital Screens',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/screen-marketplace');
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
                children: recentScreens.map<Widget>((screen) {
                  return ScreenCard(
                    screen: screen,
                    onViewSlots: () {
                      context.push('/ad-slots', extra: {
                        'parentId': screen.id,
                        'parentType': 'screen',
                        'parentName': screen.name,
                      });
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }
}
