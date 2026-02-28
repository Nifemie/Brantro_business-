import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/services/file_picker_service.dart';
import 'upload_card_widget.dart';

class CreativeFileUploadSection extends StatefulWidget {
  final VoidCallback onSubmit;

  const CreativeFileUploadSection({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CreativeFileUploadSection> createState() => _CreativeFileUploadSectionState();
}

class _CreativeFileUploadSectionState extends State<CreativeFileUploadSection> {
  File? _thumbnailFile;
  File? _creativeFile;
  String? _creativeFileUrl;
  String _selectedTab = 'upload'; // 'upload' or 'url'
  bool _agreeToTerms = false;
  final FilePickerService _filePickerService = FilePickerService();
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickThumbnail() async {
    try {
      final file = await _filePickerService.pickImage();
      if (file != null) {
        setState(() => _thumbnailFile = file);
      }
    } on FilePickerException catch (e) {
      _showError(e.message);
    }
  }

  Future<void> _pickCreativeFile() async {
    try {
      final file = await _filePickerService.pickFile();
      if (file != null) {
        setState(() => _creativeFile = file);
      }
    } on FilePickerException catch (e) {
      _showError(e.message);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _handleSubmit() {
    if (_thumbnailFile == null) {
      _showError('Please upload a thumbnail image');
      return;
    }

    if (_creativeFile == null && (_creativeFileUrl == null || _creativeFileUrl!.isEmpty)) {
      _showError('Please upload a creative file or enter a URL');
      return;
    }

    if (!_agreeToTerms) {
      _showError('Please agree to the terms and conditions');
      return;
    }

    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UploadCardWidget(
          title: 'Upload Thumbnail',
          isRequired: true,
          isDark: isDark,
          file: _thumbnailFile,
          onTap: _pickThumbnail,
          onRemove: () => setState(() => _thumbnailFile = null),
          icon: Icons.image_outlined,
          subtitle: 'JPG, PNG (Max 5MB)',
        ),
        SizedBox(height: 16.h),
        _buildCreativeFileSection(theme, isDark),
        SizedBox(height: 24.h),
        _buildTermsCheckbox(theme, isDark),
        SizedBox(height: 24.h),
        _buildUploadButton(),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildTermsCheckbox(ThemeData theme, bool isDark) {
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
      padding: EdgeInsets.all(20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _agreeToTerms,
            onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
            activeColor: AppColors.primaryColor,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                'I agree to the terms and conditions',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
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
          'Upload Creative',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCreativeFileSection(ThemeData theme, bool isDark) {
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
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Upload Creative File', isRequired: true, isDark: isDark),
          SizedBox(height: 12.h),
          _selectedTab == 'upload'
              ? (_creativeFile == null
                  ? _buildUploadArea(isDark)
                  : _buildFilePreview(isDark))
              : _buildUrlInput(isDark),
          SizedBox(height: 16.h),
          _buildTabButtons(isDark),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false, required bool isDark}) {
    return RichText(
      text: TextSpan(
        text: text,
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
    );
  }

  Widget _buildUploadArea(bool isDark) {
    return InkWell(
      onTap: _pickCreativeFile,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : AppColors.grey50,
          border: Border.all(
            color: isDark ? Colors.grey[700]! : AppColors.grey300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 40.sp,
                color: isDark ? Colors.white60 : AppColors.grey500,
              ),
              SizedBox(height: 8.h),
              Text(
                'click to upload',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white70 : AppColors.grey600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Any file format',
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

  Widget _buildUrlInput(bool isDark) {
    return TextFormField(
      controller: _urlController,
      onChanged: (value) => setState(() => _creativeFileUrl = value.isEmpty ? null : value),
      style: TextStyle(
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Enter creative file URL',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: isDark ? Colors.white38 : AppColors.grey400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : AppColors.grey300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : AppColors.grey300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
    );
  }

  Widget _buildFilePreview(bool isDark) {
    final fileName = _creativeFile!.path.split('/').last;
    final fileExtension = fileName.split('.').last.toUpperCase();
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : AppColors.grey50,
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.grey300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.insert_drive_file,
              color: AppColors.primaryColor,
              size: 32.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  fileExtension,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white60 : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _creativeFile = null),
            icon: Icon(Icons.close, color: Colors.red),
            style: IconButton.styleFrom(
              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildTabButton(
            label: 'Upload File',
            isSelected: _selectedTab == 'upload',
            onTap: () => setState(() => _selectedTab = 'upload'),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildTabButton(
            label: 'Enter File URL',
            isSelected: _selectedTab == 'url',
            onTap: () => setState(() => _selectedTab = 'url'),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? Colors.grey[800] : Colors.white)
              : Colors.transparent,
          border: Border.all(
            color: isSelected 
                ? AppColors.secondaryColor 
                : (isDark ? Colors.grey[700]! : AppColors.grey300),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected 
                  ? AppColors.secondaryColor 
                  : (isDark ? Colors.white70 : AppColors.grey600),
            ),
          ),
        ),
      ),
    );
  }
}
