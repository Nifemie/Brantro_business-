import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../ad_slot/presentation/widgets/ad_slot_dropdown_field.dart';

class AddAnnouncementDialog extends StatefulWidget {
  final Function({
    required String title,
    required String audience,
    String? category,
    String? actionText,
    String? actionUrl,
    required String description,
  }) onSubmit;

  const AddAnnouncementDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddAnnouncementDialog> createState() => _AddAnnouncementDialogState();
}

class _AddAnnouncementDialogState extends State<AddAnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _actionTextController = TextEditingController();
  final _actionUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedAudience = 'User';

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _actionTextController.dispose();
    _actionUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      backgroundColor: theme.cardTheme.color ?? (isDark ? Colors.grey[900] : Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Title & Close Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Announcement',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
                SizedBox(height: 16.h),

                // Title Field
                _buildLabel('Title', required: true),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: _buildInputDecoration(
                    hintText: 'e.g. Platform Update',
                    isDark: isDark,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Audience Field
                _buildLabel('Audience', required: true),
                SizedBox(height: 8.h),
                AdSlotDropdownField(
                  hint: 'Select',
                  value: _selectedAudience,
                  items: const ['User', 'Influencer', 'Artist', 'Brand'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedAudience = value);
                    }
                  },
                ),
                SizedBox(height: 16.h),

                // Category Field
                _buildLabel('Category'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _categoryController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: _buildInputDecoration(
                    hintText: 'e.g. home',
                    isDark: isDark,
                  ),
                ),
                SizedBox(height: 16.h),

                // Action Text Field
                _buildLabel('Action Text'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _actionTextController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: _buildInputDecoration(
                    hintText: 'e.g. Join Now',
                    isDark: isDark,
                  ),
                ),
                SizedBox(height: 16.h),

                // Action URL
                _buildLabel('Action URL'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _actionUrlController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: _buildInputDecoration(
                    hintText: 'https://example.com',
                    isDark: isDark,
                  ),
                ),
                SizedBox(height: 16.h),

                // Description *
                _buildLabel('Description', required: true),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: _buildInputDecoration(
                    hintText: 'Write the announcement details...',
                    isDark: isDark,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Action Buttons
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFEDF2F7),
                        foregroundColor: isDark ? Colors.white70 : const Color(0xFF4A5568),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35), // Orange matching mockup
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Create Announcement',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  InputDecoration _buildInputDecoration({required String hintText, required bool isDark}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : Colors.grey[400],
        fontSize: 14.sp,
      ),
      filled: true,
      fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF2D3748),
        ),
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              ]
            : [],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        title: _titleController.text,
        audience: _selectedAudience,
        category: _categoryController.text.isNotEmpty ? _categoryController.text : null,
        actionText: _actionTextController.text.isNotEmpty ? _actionTextController.text : null,
        actionUrl: _actionUrlController.text.isNotEmpty ? _actionUrlController.text : null,
        description: _descriptionController.text,
      );
      Navigator.pop(context);
    }
  }
}
