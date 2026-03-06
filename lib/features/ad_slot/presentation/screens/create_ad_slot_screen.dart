import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/create_ad_slot_form.dart';

class CreateAdSlotScreen extends ConsumerWidget {
  final String parentId;
  final String parentType; // 'billboard', 'wall', 'screen'
  final String parentName;

  const CreateAdSlotScreen({
    super.key,
    required this.parentId,
    required this.parentType,
    required this.parentName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'CREATE AD SLOT'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: CreateAdSlotForm(
                  parentId: parentId,
                  parentType: parentType,
                  parentName: parentName,
                  onCancel: () => context.pop(),
                  onSubmit: (slotData) {
                    // TODO: Save slot data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ad slot created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
