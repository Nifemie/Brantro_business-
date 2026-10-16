import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../core/service/session_service.dart';
import '../logic/kyc_provider.dart';

class KycLandingScreen extends ConsumerStatefulWidget {
  const KycLandingScreen({super.key});

  @override
  ConsumerState<KycLandingScreen> createState() => _KycLandingScreenState();
}

class _KycLandingScreenState extends ConsumerState<KycLandingScreen> {
  static const Color _accentColor = Color(0xFFFF6C2F);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(kycProvider.notifier).fetchKycStatus();
      }
    });
  }

  void _handleNavigation() {
    final kycState = ref.read(kycProvider);
    final status = kycState.verificationStatus;
    final statusResponse = kycState.statusResponse;

    final isFaceReq = statusResponse?.status == 'FACE_REQUIRED' ||
        statusResponse?.message?.contains('NIN verification completed') == true ||
        statusResponse?.message?.contains('FACE_REQUIRED') == true;

    if (status == KycVerificationStatus.approved) {
      context.go('/dashboard');
    } else if (isFaceReq) {
      context.go('/kyc/status');
    } else if (status == KycVerificationStatus.pending ||
        status == KycVerificationStatus.inReview) {
      context.go('/kyc/status');
    } else {
      context.push('/kyc/form');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryBg = isDark ? const Color(0xFF12151B) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E232D) : Colors.white;
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0);
    final iconBoxBg = _accentColor.withOpacity(isDark ? 0.15 : 0.08);
    final textPrimaryColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondaryColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final kycState = ref.watch(kycProvider);
    final status = kycState.verificationStatus;
    final statusResponse = kycState.statusResponse;

    final isFaceReq = statusResponse?.status == 'FACE_REQUIRED' ||
        statusResponse?.message?.contains('NIN verification completed') == true ||
        statusResponse?.message?.contains('FACE_REQUIRED') == true;

    String ctaText;
    if (status == KycVerificationStatus.approved) {
      ctaText = 'Continue to Dashboard →';
    } else if (isFaceReq) {
      ctaText = 'Complete Selfie Verification →';
    } else if (status == KycVerificationStatus.pending ||
        status == KycVerificationStatus.inReview) {
      ctaText = 'View Verification Status →';
    } else if (status == KycVerificationStatus.rejected) {
      ctaText = 'Resubmit Verification Details →';
    } else {
      ctaText = 'Begin Verification';
    }

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: context.canPop()
            ? IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.sp,
                    color: textPrimaryColor,
                  ),
                ),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(
          'Identity Verification',
          style: TextStyle(
            color: textPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                Icons.logout_rounded,
                size: 16.sp,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            onPressed: () async {
              await SessionService(context).logout();
            },
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero KYC Illustration Asset
                    Center(
                      child: Container(
                        height: 170.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E232D) : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: borderColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(
                            'assets/promotions/What-is-KYC.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // 2. Title & Subtitle
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: iconBoxBg,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: _accentColor.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline_rounded, size: 14.sp, color: _accentColor),
                                SizedBox(width: 6.w),
                                Text(
                                  'OFFICIAL BUSINESS VERIFICATION',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    color: _accentColor,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            isFaceReq
                                ? 'NIN Verified!\nSelfie Step Remaining'
                                : status == KycVerificationStatus.rejected
                                    ? 'Verification Unsuccessful\nAction Required'
                                    : 'Verify Your Identity to\nUnlock Full Access',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: textPrimaryColor,
                              letterSpacing: -0.5,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              isFaceReq
                                  ? 'Your NIN was accepted. Please take a quick selfie to finalize your account clearance.'
                                  : 'To safeguard your earnings and meet regulatory standards, please verify your identity in less than 2 minutes.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                color: textSecondaryColor,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Rejection Alert Banner
                    if (status == KycVerificationStatus.rejected) ...[
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(isDark ? 0.15 : 0.08),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.35)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.error_outline_rounded, color: const Color(0xFFEF4444), size: 22.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Submission Feedback',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFEF4444),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    statusResponse?.rejectionReason ??
                                        statusResponse?.message ??
                                        'Your previous submission could not be verified. Please review your details and resubmit.',
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 28.h),

                    // 3. 3-Step Process Card
                    Text(
                      'HOW IT WORKS',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: textSecondaryColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildStepRow(
                            stepNumber: '1',
                            title: 'Enter ID or Business Number',
                            description: isFaceReq
                                ? '✓ NIN uploaded and validated'
                                : 'Provide your 11-digit NIN or CAC Registration number.',
                            icon: Icons.badge_outlined,
                            iconBoxBg: iconBoxBg,
                            isDark: isDark,
                            isComplete: isFaceReq,
                            isLast: false,
                          ),
                          _buildStepRow(
                            stepNumber: '2',
                            title: 'Quick Liveness Selfie',
                            description: 'Take a quick 3-second selfie to confirm biometric match.',
                            icon: Icons.camera_front_outlined,
                            iconBoxBg: iconBoxBg,
                            isDark: isDark,
                            isActive: isFaceReq,
                            isLast: false,
                          ),
                          _buildStepRow(
                            stepNumber: '3',
                            title: 'Instant Provider Clearance',
                            description: 'Get verified instantly with unlocked withdrawals and badge.',
                            icon: Icons.verified_rounded,
                            iconBoxBg: iconBoxBg,
                            isDark: isDark,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // 4. Benefits List with Unified Icon Background & Color
                    Text(
                      'WHY VERIFICATION MATTERS',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: textSecondaryColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    _buildBenefitCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Instant Wallet Withdrawals',
                      description: 'Withdraw your creative and ad revenue directly to any Nigerian bank without delays.',
                      cardBg: cardBg,
                      borderColor: borderColor,
                      iconBoxBg: iconBoxBg,
                      textPrimaryColor: textPrimaryColor,
                      textSecondaryColor: textSecondaryColor,
                    ),
                    SizedBox(height: 10.h),
                    _buildBenefitCard(
                      icon: Icons.verified_user_rounded,
                      title: 'Trust & Verified Creator Badge',
                      description: 'Brands prioritize verified businesses and creators for high-value billboard campaigns.',
                      cardBg: cardBg,
                      borderColor: borderColor,
                      iconBoxBg: iconBoxBg,
                      textPrimaryColor: textPrimaryColor,
                      textSecondaryColor: textSecondaryColor,
                    ),
                    SizedBox(height: 10.h),
                    _buildBenefitCard(
                      icon: Icons.shield_outlined,
                      title: 'Automated Account Protection',
                      description: 'Guarantees your account cannot be impersonated or claimed by unauthorized parties.',
                      cardBg: cardBg,
                      borderColor: borderColor,
                      iconBoxBg: iconBoxBg,
                      textPrimaryColor: textPrimaryColor,
                      textSecondaryColor: textSecondaryColor,
                    ),

                    SizedBox(height: 20.h),

                    // 5. Data Privacy & Compliance
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E232D) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: iconBoxBg,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.enhanced_encryption_outlined,
                              size: 18.sp,
                              color: _accentColor,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Your information is encrypted with 256-bit SSL and processed in compliance with NDPR data protection regulations.',
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: textSecondaryColor,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // 6. Bottom Sticky CTA
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _handleNavigation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ctaText,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.arrow_forward_rounded, size: 18.sp),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Takes ~2 minutes • Fully Automated & Secure',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color iconBoxBg,
    required bool isDark,
    bool isComplete = false,
    bool isActive = false,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isComplete
                    ? const Color(0xFF10B981)
                    : isActive
                        ? _accentColor
                        : (isDark ? const Color(0xFF262C38) : const Color(0xFFE2E8F0)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isComplete
                    ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                    : Text(
                        stepNumber,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: isActive || isComplete
                              ? Colors.white
                              : (isDark ? Colors.white70 : const Color(0xFF475569)),
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 36.h,
                color: isComplete
                    ? const Color(0xFF10B981)
                    : (isDark ? Colors.white12 : const Color(0xFFCBD5E1)),
              ),
          ],
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16.sp, color: isComplete ? const Color(0xFF10B981) : _accentColor),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
              if (!isLast) SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String description,
    required Color cardBg,
    required Color borderColor,
    required Color iconBoxBg,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBoxBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.sp, color: _accentColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textSecondaryColor,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
