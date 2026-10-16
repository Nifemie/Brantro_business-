import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;
import '../../../../../core/utils/app_messanger.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_button.dart';
import '../../../logic/auth_notifiers.dart';
import '../../../data/models/forgot_password_request.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  bool _isLoading = false;

  Future<void> _forgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final identity = _identityController.text.trim();
        developer.log('🔑 [FORGOT PASSWORD] Starting with identity: $identity');

        final request = ForgotPasswordRequest(identity: identity);

        await ref.read(authNotifierProvider.notifier).forgotPassword(request);

        if (!mounted) return;

        final authState = ref.read(authNotifierProvider);

        if (authState.isDataAvailable) {
          developer.log('✅ [FORGOT PASSWORD] Success! Showing success message');
          AppMessenger.show(
            context,
            type: MessageType.success,
            message: authState.message ?? 'OTP sent to your email',
          );

          // Navigate to verification screen
          context.push(
            '/forgot-password-verification',
            extra: {'identity': identity},
          );
        } else if (authState.message != null) {
          developer.log('❌ [FORGOT PASSWORD] Error: ${authState.message}');
          AppMessenger.show(
            context,
            type: MessageType.error,
            message: authState.message!,
          );
        }
      } catch (e) {
        developer.log('❌ [FORGOT PASSWORD] Exception caught: $e');
        if (!mounted) return;
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: 'An unexpected error occurred: ${e.toString()}',
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF12151B) : Colors.white;

    return Scaffold(
      backgroundColor: primaryBg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter your registered email address or phone number to reset your password.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white60 : AppColors.grey600,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 36.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email or Phone Number',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _identityController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your email or phone number',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade400,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E232D) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: AppColors.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: AppColors.error, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email or phone number is required';
                        }

                        final trimmed = value.trim();
                        final isValidEmail = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ).hasMatch(trimmed);

                        final cleaned = trimmed.replaceAll(
                          RegExp(r'[\s\-\(\)\.+]'),
                          '',
                        );
                        final isValidPhone = RegExp(
                          r'^\d{7,15}$',
                        ).hasMatch(cleaned);

                        if (!isValidEmail && !isValidPhone) {
                          return 'Please enter a valid email address or phone number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                FullWidthButton(
                  text: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _forgotPassword,
                ),

                SizedBox(height: 20.h),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
