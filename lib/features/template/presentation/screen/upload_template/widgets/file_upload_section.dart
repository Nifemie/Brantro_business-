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

  const FileUploadSection({
    super.key,
    required this.formKey,
    required this.agreeToTerms,
    required this.onTermsChanged,
    required this.onSubmit,
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
            },
          ),

          SizedBox(height: 16.h),

          // Upload Design File
          UploadDesignFileWidget(
            isDark: isDark,
            onFileSelected: (file) {
              setState(() {
                _designFile = file;
                if (file != null) _designFileUrl = null;
              });
            },
            onUrlChanged: (url) {
              setState(() {
                _designFileUrl = url;
                if (url != null) _designFile = null;
              });
            },
          ),

          SizedBox(height: 16.h),

          // Upload Video Clip
          UploadVideoWidget(
            isDark: isDark,
            onFileSelected: (file) {
              setState(() {
                _videoFile = file;
                if (file != null) _videoUrl = null;
              });
            },
            onUrlChanged: (url) {
              setState(() {
                _videoUrl = url;
                if (url != null) _videoFile = null;
              });
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
    if (_thumbnailFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload a thumbnail image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_designFile == null && (_designFileUrl == null || _designFileUrl!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload a design file or provide a URL'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!widget.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // All validations passed, proceed with submission
    widget.onSubmit();
  }
}
