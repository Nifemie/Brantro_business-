import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';

class AdditionalDetailsForm extends StatelessWidget {
  final TextEditingController featuresController;
  final TextEditingController specificationsController;

  const AdditionalDetailsForm({
    super.key,
    required this.featuresController,
    required this.specificationsController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
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
          // Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : AppColors.grey200,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Additional Details',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),

          // Form Fields
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Features
                Text(
                  'Features (optional)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.grey700,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildRichTextEditor(
                  controller: featuresController,
                  hintText: 'e.g. Opening hours, demographic, estimated visitors...',
                  isDark: isDark,
                ),

                SizedBox(height: 20.h),

                // Specifications
                Text(
                  'Specifications (optional)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.grey700,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildRichTextEditor(
                  controller: specificationsController,
                  hintText: 'e.g. No of screens, Dimensions, Orientation, Content format, Audio support, Estimated plays...',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichTextEditor({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.grey300,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 8,
        style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: isDark ? Colors.white38 : AppColors.grey400,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
        ),
      ),
    );
  }
}
