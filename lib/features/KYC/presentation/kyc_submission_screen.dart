import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../data/kyc_models.dart';
import '../logic/kyc_provider.dart';

class KycSubmissionScreen extends ConsumerStatefulWidget {
  final KycVerificationRequest request;

  const KycSubmissionScreen({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<KycSubmissionScreen> createState() =>
      _KycSubmissionScreenState();
}

class _KycSubmissionScreenState extends ConsumerState<KycSubmissionScreen> {
  bool _isSubmitting = true;
  bool _isSuccess = false;
  String? _errorMessage;
  int _loadingPhase = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startLoadingPhaseTimer();
        _submitVerification();
      }
    });
  }

  void _startLoadingPhaseTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _isSubmitting) {
        setState(() => _loadingPhase = 1);
      }
    });
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isSubmitting) {
        setState(() => _loadingPhase = 2);
      }
    });
    Future.delayed(const Duration(seconds: 18), () {
      if (mounted && _isSubmitting) {
        setState(() => _loadingPhase = 3);
      }
    });
  }

  String _getLoadingMessage() {
    switch (_loadingPhase) {
      case 1:
        return 'Connecting to National Identity Database (NIMC)...';
      case 2:
        return 'Validating identity records and profile match...';
      case 3:
        return 'Finalizing verification request... Almost done.';
      default:
        return 'Please wait while we process your information...';
    }
  }

  Future<void> _submitVerification() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _loadingPhase = 0;
    });

    _startLoadingPhaseTimer();

    try {
      final result = await ref
          .read(kycProvider.notifier)
          .initiateKyc(widget.request)
          .timeout(
            const Duration(seconds: 35),
            onTimeout: () {
              throw Exception(
                'Verification request timed out. The NIMC or Identity gateway is taking longer than usual. Please check your internet connection and try again.',
              );
            },
          );

      if (!mounted) return;

      if (result != null) {
        final docNum = result.documentNumber?.isNotEmpty == true
            ? result.documentNumber!
            : widget.request.documentNumber;

        if (result.status == 'FACE_REQUIRED') {
          setState(() {
            _isSubmitting = false;
          });
          context.pushReplacement('/kyc/face', extra: {'documentNumber': docNum});
          return;
        }

        if (result.status == 'OTP_REQUIRED') {
          setState(() {
            _isSubmitting = false;
          });
          context.pushReplacement('/kyc/otp', extra: {'documentNumber': docNum});
          return;
        }

        // COMPLETED, APPROVED, or PENDING/IN_REVIEW
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go('/kyc/status');
          }
        });
      } else {
        setState(() {
          _isSubmitting = false;
          _isSuccess = false;
          _errorMessage = ref.read(kycProvider).error ??
              'Failed to submit verification. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSuccess = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
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
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_isSubmitting) ...[
                    // Loading State
                    SizedBox(
                      width: 72.w,
                      height: 72.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 4.w,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Submitting Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _getLoadingMessage(),
                        key: ValueKey<int>(_loadingPhase),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ] else if (_isSuccess) ...[
                    // Success State
                    Container(
                      width: 90.w,
                      height: 90.w,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 56.sp,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Verification Submitted!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Your KYC verification has been submitted successfully. We\'ll review your information and notify you within 24-48 hours.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: isDark ? Colors.blue.withOpacity(0.3) : Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: isDark ? Colors.blue[300] : Colors.blue[700],
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'You can check your verification status anytime from your profile.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isDark ? Colors.blue[200] : Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Error State
                    Container(
                      width: 90.w,
                      height: 90.w,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 56.sp,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Submission Failed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      _errorMessage ?? 'An unexpected error occurred',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Retry Button
                    ElevatedButton(
                      onPressed: _submitVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Retry Submission',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Go Back Button
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Go Back to Form',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
