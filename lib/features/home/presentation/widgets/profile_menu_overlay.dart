import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../template/logic/purchased_templates_notifier.dart';
import '../../../creatives/logic/purchased_creatives_notifier.dart';
import '../../../vetting/logic/vetting_notifier.dart';
import '../../../Digital_services/logic/purchased_services_notifier.dart';

/// Profile menu overlay widget with badge counts
class ProfileMenuOverlay extends ConsumerWidget {
  final VoidCallback onClose;

  const ProfileMenuOverlay({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers for reactive updates
    final templatesAsync = ref.watch(purchasedTemplatesProvider);
    final templatesCount = templatesAsync.asData?.value?.page.length ?? 0;
    
    final creativesAsync = ref.watch(purchasedCreativesProvider);
    final creativesCount = creativesAsync.asData?.value?.page.length ?? 0;
    
    final vettingState = ref.watch(vettingProvider);
    final vettingCount = vettingState.data?.length ?? 0;
    
    final servicesAsync = ref.watch(purchasedServicesProvider);
    final servicesCount = servicesAsync.asData?.value?.page.fold<int>(
      0, 
      (sum, order) => sum + order.items.length
    ) ?? 0;
    
    return Container(
      width: 220.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            context: context,
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () {
              onClose();
              context.push('/profile');
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.account_balance_wallet_outlined,
            label: 'Wallet',
            onTap: () {
              onClose();
              context.push('/wallet');
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.dashboard_outlined,
            label: 'My Templates',
            count: templatesCount,
            onTap: () {
              onClose();
              context.push('/my-templates');
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.business_center_outlined,
            label: 'My Services',
            count: servicesCount,
            onTap: () {
              onClose();
              context.push('/my-services');
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.verified_outlined,
            label: 'My Vetting',
            count: vettingCount,
            onTap: () {
              onClose();
              context.push('/vetting');
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.photo_library_outlined,
            label: 'My Creatives',
            count: creativesCount,
            onTap: () {
              onClose();
              context.push('/my-creatives');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    int? count,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.grey[600]),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (count != null && count > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
    );
  }
}
