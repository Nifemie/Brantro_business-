import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../data/models/ad_slot_model.dart';
import '../../logic/ad_slot_provider.dart';
import '../widgets/create_ad_slot_form.dart';

class CreateAdSlotScreen extends ConsumerWidget {
  final String parentId;
  final String parentType; // 'billboard', 'wall', 'screen'
  final String parentName;
  final bool isUpdate;
  final AdSlotModel? existingSlot;

  const CreateAdSlotScreen({
    super.key,
    required this.parentId,
    required this.parentType,
    required this.parentName,
    this.isUpdate = false,
    this.existingSlot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final adSlotState = ref.watch(adSlotProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                DashboardAppBar(
                  title: isUpdate 
                      ? (parentName.isNotEmpty ? 'UPDATE SLOT - ${parentName.toUpperCase()}' : 'UPDATE AD SLOT')
                      : (parentName.isNotEmpty ? 'CREATE SLOT - ${parentName.toUpperCase()}' : 'CREATE AD SLOT'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: CreateAdSlotForm(
                      parentId: parentId,
                      parentType: parentType,
                      parentName: parentName,
                      existingSlot: existingSlot,
                      onCancel: () => context.pop(),
                      onSubmit: (slotData) async {
                        try {
                          if (isUpdate && existingSlot != null) {
                            await ref.read(adSlotProvider.notifier).updateSlot(existingSlot!.id, slotData);
                          } else {
                            await ref.read(adSlotProvider.notifier).addSlot(slotData);
                          }
                          // Reload slots from backend to auto-refresh the parent screen
                          await ref.read(adSlotProvider.notifier).fetchSlots(parentId, parentType);
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isUpdate ? 'Slot updated successfully' : 'Slot created successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            context.pop();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString().replaceAll('Exception: ', '')),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (adSlotState.isInitialLoading)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

