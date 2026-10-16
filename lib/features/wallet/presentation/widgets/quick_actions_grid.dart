import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'quick_action_button.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: QuickActionButton(
            label: 'Withdraw',
            isPrimary: true,
            onTap: () {
              context.push('/wallet/withdraw');
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: QuickActionButton(
            label: 'Withdrawal Settings',
            isPrimary: false,
            onTap: () {
              context.push('/wallet/withdrawal-accounts');
            },
          ),
        ),
      ],
    );
  }
}
