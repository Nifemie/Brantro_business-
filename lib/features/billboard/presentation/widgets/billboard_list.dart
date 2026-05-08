import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'billboard_card.dart';
import 'billboard_menu_sheet.dart';
import '../../logic/billboard_provider.dart';

class BillboardList extends ConsumerWidget {
  const BillboardList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billboardState = ref.watch(billboardProvider);
    final billboards = billboardState.data ?? [];

    if (billboardState.isInitialLoading && billboards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(billboardProvider.notifier).refreshBillboards(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: billboards.length,
        itemBuilder: (context, index) {
          final billboard = billboards[index];
          return BillboardCard(
            image: billboard.images.isNotEmpty ? billboard.images.first : '',
            name: billboard.name,
            location: billboard.address,
            size: billboard.size,
            price: '₦${billboard.price.toStringAsFixed(0)}/month',
            isActive: billboard.isActive,
            onViewSlots: () {
              context.push('/ad-slots', extra: {
                'parentId': billboard.id,
                'parentType': 'billboard',
                'parentName': billboard.name,
              });
            },
            onMenuTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => BillboardMenuSheet(
                  billboardName: billboard.name,
                  onEdit: () {
                    Navigator.pop(context);
                    // TODO: Navigate to edit billboard
                    print('Edit ${billboard.name}');
                  },
                  onDelete: () async {
                    Navigator.pop(context);
                    final confirm = await _showDeleteConfirmation(context, billboard.name);
                    if (confirm == true) {
                      try {
                        await ref.read(billboardProvider.notifier).deleteBillboard(billboard.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Billboard deleted successfully'),
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
                  onViewDetails: () {
                    Navigator.pop(context);
                    context.push('/billboard-details', extra: {'billboard': billboard});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String billboardName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Billboard'),
        content: Text('Are you sure you want to delete "$billboardName"?'),
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
