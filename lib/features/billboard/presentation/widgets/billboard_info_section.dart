import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/billboard_model.dart';

class BillboardInfoSection extends StatelessWidget {
  final BillboardModel billboard;

  const BillboardInfoSection({
    super.key,
    required this.billboard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Billboard Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: billboard.isActive 
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  billboard.isActive ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: billboard.isActive 
                        ? const Color(0xFF10B981)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          _buildInfoRow(
            icon: Icons.category_outlined,
            label: 'Type',
            value: billboard.type,
            isDark: isDark,
          ),
          
          SizedBox(height: 12.h),
          
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: billboard.address,
            isDark: isDark,
          ),
          
          SizedBox(height: 12.h),
          
          _buildInfoRow(
            icon: Icons.straighten_outlined,
            label: 'Size',
            value: billboard.size,
            isDark: isDark,
          ),
          
          SizedBox(height: 12.h),
          
          _buildInfoRow(
            icon: Icons.attach_money_outlined,
            label: 'Price',
            value: '₦${billboard.price.toStringAsFixed(0)}/month',
            isDark: isDark,
          ),
          
          SizedBox(height: 12.h),
          
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: billboard.status,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: isDark ? Colors.white60 : Colors.grey[600],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
