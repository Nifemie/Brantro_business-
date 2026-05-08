import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/sidebar_drawer_item.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/sidebar_expandable_item.dart';
import '../../logic/navigation_provider.dart';

class SidebarNavigationList extends ConsumerWidget {
  const SidebarNavigationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeItem = ref.watch(activeNavigationProvider);

    final List<Map<String, dynamic>> menuData = [
      {'title': 'Transactions', 'icon': Icons.account_balance_wallet_outlined},
      {'title': 'Wallets', 'icon': Icons.account_balance_outlined},
      {'title': 'Complaints', 'icon': Icons.chat_bubble_outline_rounded},
      {'title': 'FAQs', 'icon': Icons.help},
      {'title': 'Contact Messages', 'icon': Icons.contact_mail},
      {'title': 'Announcements', 'icon': Icons.notifications},
      {'title': 'KYC', 'icon': Icons.admin_panel_settings},
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Text(
            'GENERAL',
            style: AppTexts.labelLarge(
              color: isDark 
                  ? Colors.grey[500]
                  : Colors.white.withOpacity(0.5),
            ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
        ),
        ...menuData.map((item) {
          return SidebarDrawerItem(
            icon: item['icon'] as IconData,
            title: item['title'] as String,
            isActive: activeItem == item['title'],
            onTap: () {
              ref.read(activeNavigationProvider.notifier).state =
                  item['title'] as String;
              Navigator.pop(context); // Close drawer
            },
          );
        }),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Divider(
            color: isDark 
                ? Colors.grey[800]
                : Colors.black.withOpacity(0.3),
            thickness: 1,
            height: 1,
          ),
        ),
        SizedBox(height: 40.h), // Bottom padding
      ],
    );
  }
}
