import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../logic/creative_provider.dart';
import 'creative_card.dart';
import 'creative_menu_sheet.dart';

class CreativeList extends ConsumerWidget {
  const CreativeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creativeState = ref.watch(creativeProvider);
    final creatives = creativeState.data ?? [];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: creatives.length,
      itemBuilder: (context, index) {
        final creative = creatives[index];
        return CreativeCard(
          bannerImage: creative.image,
          title: creative.name,
          rating: creative.rating,
          favorites: creative.favorites,
          price: creative.price,
          discount: creative.discount,
          ordersCount: creative.ordersCount,
          onViewDetails: () {
            context.push('/creative-details', extra: {'creative': creative});
          },
          onViewOrders: () {
            context.push('/orders', extra: {'creativeId': creative.id});
          },
          onMenuTap: () {
            showCreativeMenuSheet(
              context,
              creativeName: creative.name,
              onViewDetails: () {
                Navigator.pop(context);
                context.push('/creative-details', extra: {'creative': creative});
              },
              onDelete: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Creative'),
                    content: Text('Are you sure you want to delete "${creative.name}"?'),
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

                if (confirm == true) {
                  final success = await ref
                      .read(creativeProvider.notifier)
                      .deleteCreative(creative.id);
                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Creative deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      final errorMsg = ref.read(creativeProvider).message ?? 'Failed to delete creative';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMsg),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}
