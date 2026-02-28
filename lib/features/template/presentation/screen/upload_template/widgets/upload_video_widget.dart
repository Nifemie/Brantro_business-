import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/services/file_picker_service.dart';

class UploadVideoWidget extends StatefulWidget {
  final bool isDark;
  final Function(File?) onFileSelected;
  final Function(String?) onUrlChanged;

  const UploadVideoWidget({
    super.key,
    required this.isDark,
    required this.onFileSelected,
    required this.onUrlChanged,
  });

  @override
  State<UploadVideoWidget> createState() => _UploadVideoWidgetState();
}

class _UploadVideoWidgetState extends State<UploadVideoWidget> {
  String _selectedTab = 'upload'; // 'upload' or 'url'
  File? _selectedFile;
  final TextEditingController _urlController = TextEditingController();
  final FilePickerService _filePickerService = FilePickerService();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final file = await _filePickerService.pickVideo();
      if (file != null) {
        setState(() => _selectedFile = file);
        widget.onFileSelected(_selectedFile);
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

  void _removeFile() {
    setState(() {
      _selectedFile = null;
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
          _buildLabel('Upload Video Clip (Optional)'),
          SizedBox(height: 12.h),
          _selectedTab == 'upload'
              ? (_selectedFile == null
                  ? _buildUploadArea(
                      height: 120.h,
                      icon: Icons.cloud_upload_outlined,
                      text: 'click to upload',
                      subtitle: 'MP4, MOV, AVI, MKV',
                      onTap: _pickVideo,
                    )
                  : _buildFilePreview())
              : _buildUrlInput(),
          SizedBox(height: 16.h),
          _buildTabButtons(),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: widget.isDark ? Colors.white : AppColors.grey700,
      ),
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

  Widget _buildUrlInput() {
    return TextFormField(
      controller: _urlController,
      onChanged: (value) => widget.onUrlChanged(value.isEmpty ? null : value),
      style: TextStyle(
        color: widget.isDark ? Colors.white : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Enter video clip URL',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: widget.isDark ? Colors.white38 : AppColors.grey400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: widget.isDark ? Colors.grey[700]! : AppColors.grey300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: widget.isDark ? Colors.grey[700]! : AppColors.grey300,
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

  Widget _buildFilePreview() {
    final fileName = _selectedFile!.path.split('/').last;
    final fileExtension = fileName.split('.').last.toUpperCase();
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey[850] : AppColors.grey50,
        border: Border.all(
          color: widget.isDark ? Colors.grey[700]! : AppColors.grey300,
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
              Icons.videocam,
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
                    color: widget.isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  fileExtension,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: widget.isDark ? Colors.white60 : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _removeFile,
            icon: Icon(Icons.close, color: Colors.red),
            style: IconButton.styleFrom(
              backgroundColor: widget.isDark ? Colors.grey[800] : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildTabButton(
            label: 'Upload File',
            isSelected: _selectedTab == 'upload',
            onTap: () => setState(() => _selectedTab = 'upload'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildTabButton(
            label: 'Enter Design URL',
            isSelected: _selectedTab == 'url',
            onTap: () => setState(() => _selectedTab = 'url'),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? (widget.isDark ? Colors.grey[800] : Colors.white)
              : Colors.transparent,
          border: Border.all(
            color: isSelected 
                ? AppColors.secondaryColor 
                : (widget.isDark ? Colors.grey[700]! : AppColors.grey300),
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
                  : (widget.isDark ? Colors.white70 : AppColors.grey600),
            ),
          ),
        ),
      ),
    );
  }
}
