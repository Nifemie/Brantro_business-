import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/constants/kyc_constants.dart';
import '../../../../core/service/session_service.dart';
import '../../../KYC/logic/kyc_provider.dart';

class KycVerificationBanner extends ConsumerWidget {
  const KycVerificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final kycState = ref.watch(kycProvider);
    final status = kycState.verificationStatus;
    final statusResponse = kycState.statusResponse;

    // Check if approved or verified in Riverpod state
    final isStateVerified = status == KycVerificationStatus.approved ||
        statusResponse?.status == 'APPROVED' ||
        statusResponse?.status == 'VERIFIED' ||
        statusResponse?.status == 'COMPLETED';

    if (isStateVerified) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<dynamic>(
      future: SessionService.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data is Map ? snapshot.data as Map : null;
        final isUserVerified = user?['isVerified'] == true ||
            user?['kycStatus']?.toString().toUpperCase() == 'APPROVED' ||
            user?['kycStatus']?.toString().toUpperCase() == 'VERIFIED' ||
            user?['kycStatus']?.toString().toUpperCase() == 'COMPLETED';

        // Hide completely if verified in session data
        if (isUserVerified) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.secondaryColor,
                  size: 24.sp,
                ),
              ),

              SizedBox(width: 14.w),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identity Verification',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Verify your identity to unlock all platform and withdrawal features.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.white70 : AppColors.grey600,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              // Button
              ElevatedButton(
                onPressed: () {
                  context.push('/kyc');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Set up',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
