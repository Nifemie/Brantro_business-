import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_messanger.dart';
import '../../../../../core/utils/color_utils.dart';
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

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }

  Future<void> _verifyOtp() async {
    // Collect OTP from all controllers
    _otp = _otpControllers.map((controller) => controller.text).join();

    if (_otp.length != 6) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'Please enter the complete verification code',
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
          message: authState.message ?? 'OTP verified successfully',
        );

        // Navigate to reset password
        context.push('/reset-password', extra: {'identity': widget.identity});
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
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);

    try {
      // Call validateEmail to resend OTP (forgot password flow)
      // Determine if identity is email or phone
      final isEmail = widget.identity.contains('@');
      final request = ValidateAccountRequest(
        email: isEmail ? widget.identity : null,
        phoneNumber: !isEmail ? widget.identity : null,
      );
      await ref.read(authNotifierProvider.notifier).validateEmail(request);

      if (!mounted) return;

      AppMessenger.show(
        context,
        message: 'Verification code sent to your email.',
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
      setState(() => _isLoading = false);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Verify Your Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the code we sent to ${widget.identity}.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // OTP Input Fields
              _buildOtpInput(),

              const SizedBox(height: 40),

              // Didn't receive the code
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: _resendTimer == 0 ? _resendOtp : null,
                    child: Text(
                      _isLoading
                          ? 'Sending...'
                          : _resendTimer == 0
                          ? 'Resend'
                          : 'Resend in $_resendTimer seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: _resendTimer == 0
                            ? AppColors.primaryColor
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),
              const SizedBox(height: 50),

              FullWidthButton(
                text: 'Continue',
                isLoading: _isLoading,
                onPressed: _verifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build OTP Input Fields
  Widget _buildOtpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 50,
          height: 60,
          child: TextField(
            controller: _otpControllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 5) {
                  FocusScope.of(context).nextFocus();
                }
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
