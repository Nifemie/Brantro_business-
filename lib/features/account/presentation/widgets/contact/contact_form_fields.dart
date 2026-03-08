import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        Text(
          'Full Name',
          style: AppTexts.labelMedium(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: nameController,
          hintText: 'Enter your full name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Email Field
        Text(
          'Email Address',
          style: AppTexts.labelMedium(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: emailController,
          hintText: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Phone Number Field
        Text(
          'Phone Number',
          style: AppTexts.labelMedium(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: phoneController,
          hintText: 'Enter your phone number',
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
        Text(
          'Subject',
          style: AppTexts.labelMedium(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: subjectController,
          hintText: 'Enter subject',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a subject';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Address Field
        Text(
          'Address',
          style: AppTexts.labelMedium(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: addressController,
          hintText: 'Enter your address',
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
        Text(
          'Message',
          style: AppTexts.labelMedium(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: messageController,
          hintText: 'Enter your message',
          maxLines: 5,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your message';
            }
            if (value.trim().length < 10) {
              return 'Message must be at least 10 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: validator,
    );
  }
}
