import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brantro_business/features/auth/logic/auth_notifiers.dart';
import 'package:brantro_business/features/auth/data/models/verify_otp_request.dart';
import 'package:brantro_business/features/auth/data/models/validate_account_request.dart';
import 'package:brantro_business/core/utils/color_utils.dart';
import '../../../../../controllers/re_useable/app_button.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyIdentityScreen extends ConsumerStatefulWidget {
  final String email;
  final String phoneNumber;
  const VerifyIdentityScreen({
    required this.email,
    required this.phoneNumber,
    super.key,
  });

  @override
  ConsumerState<VerifyIdentityScreen> createState() =>
      _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends ConsumerState<VerifyIdentityScreen>
    with CodeAutoFill {
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;
  String _otp = '';

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

  Future<void> _verifyEmail() async {
    if (_otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete verification code'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = VerifyOtpRequest(identity: widget.email, otp: _otp);

    await ref.read(authNotifierProvider.notifier).verifyAccount(request);

    if (mounted) {
      setState(() => _isLoading = false);

      final authState = ref.read(authNotifierProvider);
      if (authState.isDataAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message ?? 'Verification successful!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to success or signin or home.
        // Assuming we go to signin or home. Let's go to signin based on context.
        context.go('/signin');
      } else if (authState.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);
    try {
      // Trigger validateEmail to resend OTP via email and SMS
      final validateRequest = ValidateAccountRequest(
        email: widget.email,
        phoneNumber: widget.phoneNumber,
      );
      await ref
          .read(authNotifierProvider.notifier)
          .validateEmail(validateRequest);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code sent to your email.')),
      );
      _startResendTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend code: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void codeUpdated() {
    setState(() {
      _otp = code ?? '';
    });
    if (_otp.length == 6) {
      _verifyEmail();
    }
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    listenForCode(); // listens for autofill/paste
    _sendOtpOnLoad(); // Trigger OTP send when screen loads
  }

  Future<void> _sendOtpOnLoad() async {
    // Trigger validateEmail to send OTP when screen loads
    final validateRequest = ValidateAccountRequest(
      email: widget.email,
      phoneNumber: widget.phoneNumber,
    );
    await ref
        .read(authNotifierProvider.notifier)
        .validateEmail(validateRequest);
  }

  @override
  void dispose() {
    _timer?.cancel();
    cancel();
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
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Verify Email Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the code we sent to ${widget.email}.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // ✅ OTP Input Fields styled like ValarPay forms
              PinFieldAutoFill(
                codeLength: 6,
                decoration: BoxLooseDecoration(
                  gapSpace: 12,
                  strokeColorBuilder: FixedColorBuilder(Colors.grey.shade400),
                  bgColorBuilder: FixedColorBuilder(
                    Colors.grey.shade50.withOpacity(0.8),
                  ),
                  radius: const Radius.circular(8),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  strokeWidth: 1.4,
                ),
                currentCode: _otp,
                onCodeChanged: (code) {
                  setState(() => _otp = code ?? '');
                  if ((code?.length ?? 0) == 6) {
                    _verifyEmail();
                  }
                },
              ),

              const SizedBox(height: 40),

              // ✅ Verify Button
              FullWidthButton(
                text: 'Verify Email',
                onPressed: _otp.length == 6 ? _verifyEmail : null,
                isLoading: _isLoading,
                isEnabled: _otp.length == 6,
              ),
              const SizedBox(height: 24),

              // Resend Code
              Center(
                child: TextButton(
                  onPressed: _resendTimer == 0 ? _resendOtp : null,
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive code? ",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      children: [
                        TextSpan(
                          text: _resendTimer == 0
                              ? 'Resend Code'
                              : 'Resend in $_resendTimer s',
                          style: TextStyle(
                            color: _resendTimer == 0
                                ? AppColors.primaryColor
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
