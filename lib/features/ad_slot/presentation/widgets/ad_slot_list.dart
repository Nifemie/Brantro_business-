import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/ad_slot_model.dart';
import '../../logic/ad_slot_provider.dart';
import 'ad_slot_item_card.dart';

class AdSlotList extends ConsumerWidget {
  final List<AdSlotModel> slots;
  final String parentType;

  const AdSlotList({
    super.key,
    required this.slots,
    required this.parentType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        if (slots.isNotEmpty) {
          await ref.read(adSlotProvider.notifier).fetchSlots(
            slots.first.parentId,
            slots.first.parentType,
          );
        }
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: slots.length,
        itemBuilder: (context, index) {
          final slot = slots[index];
          return AdSlotItemCard(
            slot: slot,
            onEdit: () {
              // TODO: Navigate to edit slot
              print('Edit slot ${slot.slotNumber}');
            },
            onDelete: () async {
              final confirm = await _showDeleteConfirmation(context, slot.slotNumber);
              if (confirm == true) {
                try {
                  await ref.read(adSlotProvider.notifier).deleteSlot(slot.id);
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
        },
      ),
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
