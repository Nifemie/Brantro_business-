import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../vehicle/logic/vehicle_provider.dart';
import '../../../../vehicle/presentation/widgets/vehicle_card.dart';
import '../../../../../core/widgets/empty_state.dart';

class RecentVehiclesSection extends ConsumerWidget {
  const RecentVehiclesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final vehiclesState = ref.watch(vehicleProvider);
    final sortedData = List.of(vehiclesState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentVehicles = sortedData.take(3).toList();

    if (recentVehicles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Vehicles',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/vehicle-marketplace');
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
                children: recentVehicles.map<Widget>((vehicle) {
                  return VehicleCard(
                    vehicle: vehicle,
                    onViewSlots: () {
                      context.push('/ad-slots', extra: {
                        'parentId': vehicle.id,
                        'parentType': 'vehicle',
                        'parentName': vehicle.name,
                      });
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }
}
