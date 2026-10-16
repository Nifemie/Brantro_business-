import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';

class ContactFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController subjectController;
  final TextEditingController addressController;
  final TextEditingController messageController;

  const ContactFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.subjectController,
    required this.addressController,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        _buildLabel('Full Name', isDark: isDark),
        SizedBox(height: 8.h),
        _buildTextField(
          context: context,
          controller: nameController,
          hintText: 'e.g. Aisha Buhari',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Email Field
        _buildLabel('Email Address', isDark: isDark),
        SizedBox(height: 8.h),
        _buildTextField(
          context: context,
          controller: emailController,
          hintText: 'e.g. yourname@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Phone Number Field
        _buildLabel('Phone Number', isDark: isDark),
        SizedBox(height: 8.h),
        _buildTextField(
          context: context,
          controller: phoneController,
          hintText: 'e.g. 08064160204',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Subject Field
        _buildLabel('Subject', isDark: isDark),
        SizedBox(height: 8.h),
        _buildTextField(
          context: context,
          controller: subjectController,
          hintText: 'e.g. Campaign Inquiry or Support Ticket',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a subject';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Address Field
        _buildLabel('Address', isDark: isDark),
        SizedBox(height: 8.h),
        _buildTextField(
          context: context,
          controller: addressController,
          hintText: 'e.g. Suite 12, Commercial Plaza, Lagos, Nigeria',
          maxLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Message Field
        _buildLabel('Message', isDark: isDark),
        SizedBox(height: 8.h),
        _buildTextField(
          context: context,
          controller: messageController,
          hintText: 'Write your message or inquiry here...',
          maxLines: 5,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your message';
            }
            if (value.trim().length < 5) {
              return 'Message must be at least 5 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {required bool isDark}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: isDark ? Colors.white38 : AppColors.grey400,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E232D) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: validator,
    );
  }
}
