import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/services/file_picker_service.dart';

class UploadThumbnailWidget extends StatefulWidget {
  final bool isDark;
  final Function(File?) onFileSelected;

  const UploadThumbnailWidget({
    super.key,
    required this.isDark,
    required this.onFileSelected,
  });

  @override
  State<UploadThumbnailWidget> createState() => _UploadThumbnailWidgetState();
}

class _UploadThumbnailWidgetState extends State<UploadThumbnailWidget> {
  File? _selectedImage;
  final FilePickerService _filePickerService = FilePickerService();

  Future<void> _pickImage() async {
    try {
      final file = await _filePickerService.pickImage();
      if (file != null) {
        setState(() => _selectedImage = file);
        widget.onFileSelected(_selectedImage);
      }
    } on FilePickerException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onFileSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: widget.isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Upload Thumbnail', isRequired: true),
          SizedBox(height: 12.h),
          _selectedImage == null
              ? _buildUploadArea(
                  height: 200.h,
                  icon: Icons.image_outlined,
                  text: 'click to upload',
                  onTap: _pickImage,
                )
              : _buildImagePreview(),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: widget.isDark ? Colors.white : AppColors.grey700,
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
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.grey[850] : AppColors.grey50,
            border: Border.all(
              color: widget.isDark ? Colors.grey[700]! : AppColors.grey300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Row(
            children: [
              IconButton(
                onPressed: _pickImage,
                icon: Icon(Icons.edit, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: EdgeInsets.all(8.w),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: _removeImage,
                icon: Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.8),
                  padding: EdgeInsets.all(8.w),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadArea({
    required double height,
    required IconData icon,
    required String text,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.grey[850] : AppColors.grey50,
          border: Border.all(
            color: widget.isDark ? Colors.grey[700]! : AppColors.grey300,
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
                color: widget.isDark ? Colors.white60 : AppColors.grey500,
              ),
              SizedBox(height: 8.h),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: widget.isDark ? Colors.white70 : AppColors.grey600,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: widget.isDark ? Colors.white60 : AppColors.grey500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
