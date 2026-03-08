import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import 'widgets/profile_text_field.dart';
import 'widgets/profile_media_section.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? userData;

  const EditProfileScreen({super.key, this.userData});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.userData?['fullName'] ?? 'Brantro Admin',
    );
    _phoneController = TextEditingController(
      text: widget.userData?['phone'] ?? '09087614673277',
    );
    _bioController = TextEditingController(
      text: widget.userData?['bio'] ?? 'Tell us about yourself',
    );
    _countryController = TextEditingController(
      text: widget.userData?['country'] ?? 'Nigeria',
    );
    _stateController = TextEditingController(
      text: widget.userData?['state'] ?? 'Delta',
    );
    _cityController = TextEditingController(
      text: widget.userData?['city'] ?? 'Delta Central',
    );
    _addressController = TextEditingController(
      text: widget.userData?['address'] ?? 'In beatae quod sequi',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E2329)
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        // Set AppBar explicitly background to the same color to blend in
        backgroundColor: isDark
            ? const Color(0xFF1E2329)
            : AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.white,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileMediaSection(),
                SizedBox(height: 32.h),
                _buildSectionHeader('Edit Profile Information', isDark),
                SizedBox(height: 24.h),

                ProfileTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                ),
                SizedBox(height: 20.h),
                ProfileTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20.h),
                ProfileTextField(
                  controller: _bioController,
                  label: 'Bio',
                  maxLines: 4,
                ),

                SizedBox(height: 32.h),
                _buildSectionHeader('Address Details', isDark),
                SizedBox(height: 24.h),

                ProfileTextField(
                  controller: _countryController,
                  label: 'Country',
                ),
                SizedBox(height: 20.h),
                ProfileTextField(controller: _stateController, label: 'State'),
                SizedBox(height: 20.h),
                ProfileTextField(controller: _cityController, label: 'City'),
                SizedBox(height: 20.h),
                ProfileTextField(
                  controller: _addressController,
                  label: 'Address',
                  maxLines: 2,
                ),

                SizedBox(height: 48.h),

                // Save Changes button - Full Width Fintech Style
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6C2F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFFFF6C2F).withOpacity(0.4),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[300] : AppColors.grey800,
          ),
        ),
        if (title == 'Edit Profile Information') ...[
          SizedBox(height: 8.h),
          Divider(color: isDark ? Colors.white10 : Colors.grey[300]),
        ],
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual save logic with API call
      // For now, just show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Go back to profile details
      context.pop();
    }
  }
}
