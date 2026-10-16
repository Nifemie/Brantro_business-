import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_messanger.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_button.dart';
import '../../../logic/auth_notifiers.dart';
import '../../../data/models/verify_otp_request.dart';
import '../../../data/models/validate_account_request.dart';

class ForgotPasswordVerificationScreen extends ConsumerStatefulWidget {
  final String identity;
  const ForgotPasswordVerificationScreen({required this.identity, super.key});

  @override
  ConsumerState<ForgotPasswordVerificationScreen> createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends ConsumerState<ForgotPasswordVerificationScreen> {
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;
  String _otp = '';
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        if (mounted) setState(() {});
      } else {
        if (mounted) {
          setState(() {
            _resendTimer--;
          });
        }
      }
    });
  }

  Future<void> _verifyOtp() async {
    _otp = _otpControllers.map((controller) => controller.text.trim()).join();

    if (_otp.length != 6) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'Please enter the complete 6-digit verification code',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = VerifyOtpRequest(identity: widget.identity, otp: _otp);
      await ref.read(authNotifierProvider.notifier).verifyAccount(request);

      if (!mounted) return;

      final authState = ref.read(authNotifierProvider);
      if (authState.isDataAvailable) {
        AppMessenger.show(
          context,
          type: MessageType.success,
          message: authState.message ?? 'Code verified successfully',
        );

        // Navigate to reset password
        context.push('/reset-password', extra: {
          'identity': widget.identity,
          'otp': _otp,
        });
      } else if (authState.message != null) {
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: authState.message!,
        );
      }
    } catch (e) {
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

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);

    try {
      final isEmail = widget.identity.contains('@');
      final request = ValidateAccountRequest(
        email: isEmail ? widget.identity : null,
        phoneNumber: !isEmail ? widget.identity : null,
      );
      await ref.read(authNotifierProvider.notifier).validateEmail(request);

      if (!mounted) return;

      AppMessenger.show(
        context,
        message: 'Verification code resent successfully.',
        type: MessageType.success,
      );

      _startResendTimer();
    } catch (e) {
      if (!mounted) return;
      AppMessenger.show(
        context,
        message: 'Failed to resend code: ${e.toString()}',
        type: MessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF12151B) : Colors.white;

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verify Your Account',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Enter the 6-digit code sent to\n${widget.identity}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white60 : AppColors.grey600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),

              // OTP Input Fields
              _buildOtpInput(isDark),

              SizedBox(height: 36.h),

              // Didn't receive the code
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white60 : AppColors.grey600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resendTimer == 0 && !_isLoading ? _resendOtp : null,
                    child: Text(
                      _isLoading
                          ? 'Sending...'
                          : _resendTimer == 0
                              ? 'Resend'
                              : 'Resend in $_resendTimer s',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _resendTimer == 0
                            ? AppColors.primaryColor
                            : (isDark ? Colors.white38 : Colors.grey),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),

              FullWidthButton(
                text: 'Continue',
                isLoading: _isLoading,
                onPressed: _verifyOtp,
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // Build OTP Input Fields with high contrast and clear visibility
  Widget _buildOtpInput(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 48.w,
          height: 56.h,
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: isDark ? const Color(0xFF1E232D) : const Color(0xFFF8FAFC),
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                  _verifyOtp();
                }
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
