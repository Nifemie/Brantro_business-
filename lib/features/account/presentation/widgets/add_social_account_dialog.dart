import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';

class AddSocialAccountDialog extends StatefulWidget {
  final Function({
    required String platform,
    required String username,
    required String profileUrl,
    required int followersCount,
    required bool isPrimary,
    required bool isActive,
  }) onSubmit;

  const AddSocialAccountDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddSocialAccountDialog> createState() => _AddSocialAccountDialogState();
}

class _AddSocialAccountDialogState extends State<AddSocialAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _profileUrlController = TextEditingController();
  final _followersController = TextEditingController(text: '0');

  String? _selectedPlatform;
  bool _isPrimary = false;
  bool _isActive = true;

  final List<String> _platforms = [
    'Facebook',
    'TikTok',
    'Instagram',
    'Twitter/X',
    'YouTube',
    'LinkedIn',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _profileUrlController.dispose();
    _followersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      backgroundColor: theme.cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : AppColors.grey200,
          width: 1,
        ),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 550.w),
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
                        'Add Social Account',
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
                          size: 22.sp,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Divider(color: isDark ? Colors.grey[800] : AppColors.grey200),
                  SizedBox(height: 16.h),

                  // Platform Field
                  _buildLabel('Platform', isDark: isDark),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: _selectedPlatform,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    hint: Text(
                      'Select Platform',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white60 : AppColors.grey500,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: _buildInputDecoration(isDark: isDark),
                    items: _platforms.map((platform) {
                      return DropdownMenuItem<String>(
                        value: platform,
                        child: Text(platform),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPlatform = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Handle / Username Field
                  _buildLabel('Handle / Username', isDark: isDark),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: _buildInputDecoration(
                      hintText: '@username',
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

                  // Profile URL Field
                  _buildLabel('Profile URL', isDark: isDark),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _profileUrlController,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: _buildInputDecoration(
                      hintText: 'https://platform.com/username',
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

                  // Followers Count Field
                  _buildLabel('Followers Count', isDark: isDark),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _followersController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: _buildInputDecoration(
                      hintText: '0',
                      isDark: isDark,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Must be a number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Is Primary & Is Active — side by side checkboxes
                  Row(
                    children: [
                      // Is Primary Checkbox
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Checkbox(
                          value: _isPrimary,
                          activeColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          side: BorderSide(
                            color: isDark ? Colors.grey[600]! : AppColors.grey400,
                            width: 1.5,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isPrimary = value ?? false;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Is Primary',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : AppColors.grey700,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      // Is Active Checkbox
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Checkbox(
                          value: _isActive,
                          activeColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          side: BorderSide(
                            color: isDark ? Colors.grey[600]! : AppColors.grey400,
                            width: 1.5,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isActive = value ?? false;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Is Active',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Actions Row: Cancel & Add Account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFF1F3F6),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppColors.grey700,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onSubmit(
                              platform: _selectedPlatform!,
                              username: _usernameController.text.trim(),
                              profileUrl: _profileUrlController.text.trim(),
                              followersCount: int.parse(_followersController.text.trim()),
                              isPrimary: _isPrimary,
                              isActive: _isActive,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Add Account',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

  Widget _buildLabel(String label, {required bool isDark}) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : AppColors.grey700,
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hintText, required bool isDark}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: isDark ? Colors.white30 : AppColors.grey400,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      filled: true,
      fillColor: isDark ? const Color(0xFF2B2B2B) : Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[800]! : const Color(0xFFDCDAE0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
    );
  }
}
