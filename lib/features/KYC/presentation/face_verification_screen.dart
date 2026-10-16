import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../core/utils/base64_helper.dart';
import '../logic/kyc_provider.dart';

class FaceVerificationScreen extends ConsumerStatefulWidget {
  final String documentNumber;

  const FaceVerificationScreen({
    super.key,
    required this.documentNumber,
  });

  @override
  ConsumerState<FaceVerificationScreen> createState() =>
      _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends ConsumerState<FaceVerificationScreen> {
  File? _capturedImage;
  bool _isVerifying = false;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 350,
        maxHeight: 350,
        imageQuality: 40,
      );

      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to capture image. Please check camera permissions.';
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 350,
        maxHeight: 350,
        imageQuality: 40,
      );

      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to select image. Please try again.';
      });
    }
  }

  Future<void> _submitVerification() async {
    if (_capturedImage == null) {
      setState(() {
        _errorMessage = 'Please capture or select a selfie first';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      // Convert image to data URI base64 string
      final imageBase64 = await Base64Helper.fileToDataUri(_capturedImage!);

      final success = await ref
          .read(kycProvider.notifier)
          .verifyFace(widget.documentNumber, imageBase64);

      if (mounted) {
        setState(() {
          _isVerifying = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Identity verified successfully!'),
              backgroundColor: Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );

          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              context.go('/kyc/status');
            }
          });
        } else {
          final error = ref.read(kycProvider).error;
          setState(() {
            _errorMessage = error ??
                'Face verification failed. Please ensure your face is well-lit and matches your NIN photo.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _errorMessage = 'Verification failed: ${e.toString().replaceAll('Exception: ', '')}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF12151B) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E232D) : Colors.white;
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Face Verification',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title & Subtitle
              Text(
                'Selfie Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Identro automated match requires a clear selfie to match against your National Identity records.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: secondaryTextColor,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 24.h),

              // Image Preview or Placeholder Frame
              Container(
                width: 240.w,
                height: 280.h,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: _capturedImage != null
                        ? AppColors.primaryColor
                        : borderColor,
                    width: _capturedImage != null ? 2.5 : 1.5,
                  ),
                ),
                child: _capturedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18.r),
                        child: Image.file(
                          _capturedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72.w,
                            height: 72.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.face_rounded,
                                size: 40.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            'No photo captured yet',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: secondaryTextColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Tap "Take Selfie" below',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: secondaryTextColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
              ),

              SizedBox(height: 16.h),

              // Retake Button
              if (_capturedImage != null)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _capturedImage = null;
                      _errorMessage = null;
                    });
                  },
                  icon: Icon(Icons.refresh, size: 18.sp, color: AppColors.primaryColor),
                  label: Text(
                    'Retake Photo',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),

              SizedBox(height: 16.h),

              // Guidelines Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 26.w,
                          height: 26.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: AppColors.primaryColor,
                              size: 16.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Instructions for Instant Approval',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildGuideline('Face the front camera directly', primaryTextColor, secondaryTextColor),
                    _buildGuideline('Ensure your face is well-lit without shadows', primaryTextColor, secondaryTextColor),
                    _buildGuideline('Remove glasses, masks, and head coverings', primaryTextColor, secondaryTextColor),
                    _buildGuideline('Maintain a neutral expression with eyes open', primaryTextColor, secondaryTextColor),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Error Message
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF7F1D1D).withOpacity(0.4) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: const Color(0xFFEF4444),
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Capture / Submit Action Buttons
              if (_capturedImage == null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton.icon(
                    onPressed: _captureImage,
                    icon: Icon(Icons.camera_alt, size: 20.sp, color: Colors.white),
                    label: Text(
                      'Take Selfie with Camera',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: Icon(Icons.photo_library_outlined, size: 18.sp, color: AppColors.primaryColor),
                    label: Text(
                      'Upload from Gallery',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _submitVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.6),
                    ),
                    child: _isVerifying
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20.w,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Matching Face with NIMC...',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Submit & Verify Identity',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideline(String text, Color primaryText, Color secondaryText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 16.sp,
            color: const Color(0xFF10B981),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: secondaryText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
