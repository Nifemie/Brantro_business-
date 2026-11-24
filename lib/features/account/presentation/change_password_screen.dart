import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/core/service/session_service.dart';
import 'package:brantro_business/core/utils/app_messanger.dart';
import 'package:brantro_business/features/auth/data/models/reset_password_request.dart';
import 'package:brantro_business/features/auth/logic/auth_notifiers.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/dashboard_app_bar.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final user = await SessionService.getUser();
      if (user != null) {
        setState(() {
          _userEmail = user['emailAddress'] ?? user['email'] ?? user['username'] ?? '';
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_userEmail.isEmpty) {
      AppMessenger.show(
        context,
        message: 'Could not resolve user identity. Please re-login and try again.',
        type: MessageType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final request = ResetPasswordRequest(
        identity: _userEmail.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      final response = await authRepo.resetPassword(request);

      if (mounted) {
        setState(() => _isLoading = false);
        AppMessenger.show(
          context,
          message: response.message.isNotEmpty
              ? response.message
              : 'Password changed successfully!',
          type: MessageType.success,
        );
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted && context.canPop()) {
            context.pop();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppMessenger.show(
          context,
          message: e.toString().replaceAll('Exception: ', ''),
          type: MessageType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'CHANGE PASSWORD'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header info banner
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.secondaryColor,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Update Account Password',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    _userEmail.isNotEmpty
                                        ? 'Logged in as: $_userEmail'
                                        : 'Set a new password to secure your account.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // New Password
                      Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNew,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white30 : Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E212B) : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white12 : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white12 : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(
                              color: AppColors.secondaryColor,
                              width: 1.5,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.vpn_key_outlined,
                            size: 20.sp,
                            color: isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 20.sp,
                              color: isDark ? Colors.white54 : Colors.grey.shade500,
                            ),
                            onPressed: () => setState(() => _obscureNew = !_obscureNew),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (val.trim().length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Confirm Password
                      Text(
                        'Confirm New Password',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Re-enter new password',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white30 : Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E212B) : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white12 : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white12 : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(
                              color: AppColors.secondaryColor,
                              width: 1.5,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.check_circle_outline,
                            size: 20.sp,
                            color: isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 20.sp,
                              color: isDark ? Colors.white54 : Colors.grey.shade500,
                            ),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (val.trim() != _newPasswordController.text.trim()) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Password requirements hint
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16.sp,
                              color: AppColors.secondaryColor,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Must be at least 6 characters. Use letters, numbers, and symbols for better security.',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 36.h),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleChangePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Update Password',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
