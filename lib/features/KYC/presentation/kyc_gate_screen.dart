import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../logic/kyc_provider.dart';
import 'widgets/kyc_status_badge.dart';

class KycGateScreen extends ConsumerWidget {
  final String requiredFor;
  final String? returnRoute;

  const KycGateScreen({
    super.key,
    required this.requiredFor,
    this.returnRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final kycState = ref.watch(kycProvider);
    final status = kycState.verificationStatus;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'KYC Required',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Icon
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  size: 50.sp,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 32.h),

              // Title
              Text(
                'Verification Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 12.h),

              // Description
              Text(
                'You need to complete KYC verification before $requiredFor.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),

              // Current Status
              KycStatusBadge(
                status: status,
                showDescription: true,
              ),
              SizedBox(height: 32.h),

              // Why KYC is needed
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: isDark ? Colors.blue.withOpacity(0.3) : Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: isDark ? Colors.blue[300] : Colors.blue[700],
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Why is KYC required?',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.blue[200] : Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildReason(context, 'Protect buyers and sellers'),
                    _buildReason(context, 'Prevent fraud and scams'),
                    _buildReason(context, 'Comply with regulations'),
                    _buildReason(context, 'Build trust in the marketplace'),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              if (status == KycVerificationStatus.notStarted) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/kyc');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Start KYC Verification',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else if (status == KycVerificationStatus.pending ||
                  status == KycVerificationStatus.inReview) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/kyc/status');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Check Verification Status',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else if (status == KycVerificationStatus.rejected) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/kyc/form');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Resubmit Verification',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 12.h),

              // Not Now Button
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Not Now',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReason(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16.sp,
            color: isDark ? Colors.blue[300] : Colors.blue[700],
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.blue[200] : Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
