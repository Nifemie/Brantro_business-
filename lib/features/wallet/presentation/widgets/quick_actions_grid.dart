import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'quick_action_button.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: QuickActionButton(
            label: 'Fund Wallet',
            isPrimary: true,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add money screen coming soon')),
              );
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: QuickActionButton(
            label: 'Withdraw',
            isPrimary: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Withdraw screen coming soon')),
              );
            },
          ),
        ),
      ],
    );
  }
}
