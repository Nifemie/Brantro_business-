import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/services/file_picker_service.dart';

class UploadCardWidget extends StatelessWidget {
  final String title;
  final bool isRequired;
  final bool isDark;
  final File? file;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final IconData icon;
  final String subtitle;

  const UploadCardWidget({
    super.key,
    required this.title,
    required this.isRequired,
    required this.isDark,
    required this.file,
    required this.onTap,
    required this.onRemove,
    required this.icon,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.grey700,
              ),
              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          SizedBox(height: 12.h),
          if (file == null)
            _buildUploadArea()
          else
            _buildFilePreview(),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : AppColors.grey50,
          border: Border.all(
            color: isDark ? Colors.grey[700]! : AppColors.grey300,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.sp,
                color: isDark ? Colors.white60 : AppColors.grey500,
              ),
              SizedBox(height: 8.h),
              Text(
                'Click to upload',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white70 : AppColors.grey600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.white60 : AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    final filePickerService = FilePickerService();
    final fileName = filePickerService.getFileName(file!.path);
    final isImage = filePickerService.isImageFile(file!.path);

    return Stack(
      children: [
        Container(
          height: 150.h,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : AppColors.grey50,
            border: Border.all(
              color: isDark ? Colors.grey[700]! : AppColors.grey300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: isImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    file!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        size: 40.sp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          fileName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.close, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.8),
              padding: EdgeInsets.all(8.w),
            ),
          ),
        ),
      ],
    );
  }
}
