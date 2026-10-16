import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import 'upload_thumbnail_widget.dart';
import 'upload_design_file_widget.dart';
import 'upload_video_widget.dart';
import 'terms_conditions_widget.dart';

class FileUploadSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool agreeToTerms;
  final Function(bool) onTermsChanged;
  final VoidCallback onSubmit;
  final Function(File?) onThumbnailSelected;
  final Function(File?) onDesignFileSelected;
  final Function(String?) onDesignUrlChanged;
  final Function(File?) onVideoSelected;
  final Function(String?) onVideoUrlChanged;

  const FileUploadSection({
    super.key,
    required this.formKey,
    required this.agreeToTerms,
    required this.onTermsChanged,
    required this.onSubmit,
    required this.onThumbnailSelected,
    required this.onDesignFileSelected,
    required this.onDesignUrlChanged,
    required this.onVideoSelected,
    required this.onVideoUrlChanged,
  });

  @override
  State<FileUploadSection> createState() => _FileUploadSectionState();
}

class _FileUploadSectionState extends State<FileUploadSection> {
  File? _thumbnailFile;
  File? _designFile;
  String? _designFileUrl;
  File? _videoFile;
  String? _videoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload Thumbnail
          UploadThumbnailWidget(
            isDark: isDark,
            onFileSelected: (file) {
              setState(() {
                _thumbnailFile = file;
              });
              widget.onThumbnailSelected(file);
            },
          ),

          SizedBox(height: 16.h),

          // Upload Design File
          UploadDesignFileWidget(
            isDark: isDark,
            onFileSelected: (file) {
              setState(() {
                _designFile = file;
              });
              widget.onDesignFileSelected(file);
            },
            onUrlChanged: (url) {
              setState(() {
                _designFileUrl = url;
              });
              widget.onDesignUrlChanged(url);
            },
          ),

          SizedBox(height: 16.h),

          // Upload Video Clip
          UploadVideoWidget(
            isDark: isDark,
            onFileSelected: (file) {
              setState(() {
                _videoFile = file;
              });
              widget.onVideoSelected(file);
            },
            onUrlChanged: (url) {
              setState(() {
                _videoUrl = url;
              });
              widget.onVideoUrlChanged(url);
            },
          ),

          SizedBox(height: 24.h),

          // Terms & Conditions
          TermsConditionsWidget(
            isDark: isDark,
            agreeToTerms: widget.agreeToTerms,
            onTermsChanged: widget.onTermsChanged,
          ),

          SizedBox(height: 24.h),

          // Upload Template Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Upload Template',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  void _handleSubmit() {
    widget.onSubmit();
  }
}
