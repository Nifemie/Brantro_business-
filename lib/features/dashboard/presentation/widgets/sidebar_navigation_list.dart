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
    final activeItem = ref.watch(activeNavigationProvider);

    final List<Map<String, dynamic>> menuData = [
      {'title': 'Dashboard', 'icon': Icons.grid_view_rounded},
      {
        'title': 'Templates',
        'icon': Icons.style_outlined,
        'children': ['Marketplace', 'Orders'],
      },
      {
        'title': 'Creatives',
        'icon': Icons.palette_outlined,
        'children': ['Marketplace', 'Orders'],
      },
      {
        'title': 'Services',
        'icon': Icons.business_center_outlined,
        'children': ['Marketplace', 'Orders'],
      },
      {
        'title': 'Manage Billboard',
        'icon': Icons.map_outlined,
        'children': ['Billboard', 'Ad Slots', 'Campaign Order', 'Ads proof'],
      },
      {
        'title': 'Manage Screen',
        'icon': Icons.videocam_outlined,
        'children': [
          'Digital Screen',
          'Ad Slots',
          'Campaign Order',
          'Placement',
          'Ads Proof',
        ],
      },
      {
        'title': 'Manage Walls',
        'icon': Icons.wallpaper_outlined,
        'children': [
          'Wall',
          'Ad Slots',
          'Campaign Order',
          'Placement',
          'Ads Proof',
        ],
      },
      {'title': 'Vetting Plans', 'icon': Icons.receipt_long_outlined},
      {'title': 'Vetting Requests', 'icon': Icons.forum_outlined},
      {'title': 'Transactions', 'icon': Icons.account_balance_wallet_outlined},
      {'title': 'Wallets', 'icon': Icons.account_balance_outlined},
      {'title': 'Complaints', 'icon': Icons.chat_bubble_outline_rounded},
      {'title': 'FAQs', 'icon': Icons.help},
      {'title': 'Contact Messages', 'icon': Icons.contact_mail},
      {'title': 'Announcements', 'icon': Icons.notifications},
      {'title': 'KYC', 'icon': Icons.admin_panel_settings},
      {'title': 'KYC Admin', 'icon': Icons.admin_panel_settings},
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Text(
            'GENERAL',
            style: AppTexts.labelLarge(
              color: Colors.white.withOpacity(0.5),
            ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
        ),
        ...menuData.map((item) {
          if (item.containsKey('children')) {
            final itemTitle = item['title'] as String;
            final isActive =
                activeItem == itemTitle ||
                activeItem.startsWith('$itemTitle-');

            return SidebarExpandableDrawerItem(
              icon: item['icon'] as IconData,
              title: itemTitle,
              isActive: isActive,
              onExpansionChanged: (expanded) {
                if (expanded && !isActive) {
                  ref.read(activeNavigationProvider.notifier).state = itemTitle;
                }
              },
              children: (item['children'] as List<String>).map((childTitle) {
                final itemKey = '$itemTitle-$childTitle';
                final isSubActive = activeItem == itemKey;

                return SidebarSubItem(
                  title: childTitle,
                  isActive: isSubActive,
                  onTap: () {
                    ref.read(activeNavigationProvider.notifier).state = itemKey;
                    
                    // Navigate based on the item
                    if (itemTitle == 'Templates' && childTitle == 'Marketplace') {
                      Navigator.pop(context); // Close drawer
                      context.go('/template-marketplace');
                    } else if (itemTitle == 'Creatives' && childTitle == 'Marketplace') {
                      Navigator.pop(context); // Close drawer
                      context.go('/creative-marketplace');
                    }
                  },
                );
              }).toList(),
            );
          } else {
            return SidebarDrawerItem(
              icon: item['icon'] as IconData,
              title: item['title'] as String,
              isActive: activeItem == item['title'],
              onTap: () {
                ref.read(activeNavigationProvider.notifier).state = item['title'] as String;
                if (item['title'] == 'Dashboard') {
                  Navigator.pop(context); // Close drawer
                  context.go('/dashboard'); // Navigate to dashboard
                }
              },
            );
          }
        }),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Divider(
            color: Colors.black.withOpacity(0.3),
            thickness: 1,
            height: 1,
          ),
        ),
        SizedBox(height: 40.h), // Bottom padding
      ],
    );
  }
}
