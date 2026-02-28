import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../logic/profile_provider.dart';

class AccountMenuSection extends ConsumerWidget {
  const AccountMenuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileDataAsync = ref.watch(profileHeaderProvider);

    return profileDataAsync.when(
      data: (profileData) => _buildPersonalInfo(profileData),
      loading: () => _buildLoadingSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPersonalInfo(ProfileHeaderData profileData) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
          Divider(height: 1, thickness: 1, color: AppColors.grey200),
          SizedBox(height: 8.h),
          
          // Role
          _buildInfoItem(
            icon: Icons.work_outline,
            label: _formatRole(profileData.role),
            iconColor: AppColors.grey600,
          ),
          
          // Location
          if (profileData.location.isNotEmpty)
            _buildInfoItem(
              icon: Icons.location_on_outlined,
              label: 'Lives in ${profileData.location}',
              iconColor: AppColors.grey600,
            ),
          
          // Followers
          _buildInfoItem(
            icon: Icons.people_outline,
            label: 'Followed by ${profileData.followers} People',
            iconColor: AppColors.grey600,
          ),
          
          // Email
          if (profileData.email.isNotEmpty)
            _buildInfoItem(
              icon: Icons.email_outlined,
              label: 'Email ${profileData.email}',
              iconColor: AppColors.grey600,
              valueColor: AppColors.secondaryColor,
            ),
          
          // Phone
          if (profileData.phoneNumber.isNotEmpty)
            _buildInfoItem(
              icon: Icons.phone_outlined,
              label: 'Phone ${profileData.phoneNumber}',
              iconColor: AppColors.grey600,
            ),
          
          // Status
          _buildInfoItem(
            icon: Icons.check_circle_outline,
            label: 'Status',
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: profileData.status == 'ACTIVE' 
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                profileData.status == 'ACTIVE' ? 'Active' : profileData.status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: profileData.status == 'ACTIVE' 
                      ? AppColors.success
                      : AppColors.grey600,
                ),
              ),
            ),
            iconColor: AppColors.grey600,
          ),
          
          // Rating
          _buildInfoItem(
            icon: Icons.star_outline,
            label: 'Rating ${profileData.rating.toStringAsFixed(1)}  (${profileData.reviewsCount} reviews)',
            iconColor: AppColors.secondaryColor,
          ),
          
          SizedBox(height: 16.h),
        ],
      ),
    );
      },
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    Color? valueColor,
    Widget? trailing,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : AppColors.grey100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: valueColor ?? (isDark ? Colors.white : AppColors.grey700),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 150.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRole(String role) {
    return role
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
