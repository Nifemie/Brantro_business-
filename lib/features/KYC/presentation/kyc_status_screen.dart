import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../core/service/session_service.dart';
import '../logic/kyc_provider.dart';

class KycStatusScreen extends ConsumerStatefulWidget {
  const KycStatusScreen({super.key});

  @override
  ConsumerState<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends ConsumerState<KycStatusScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refresh();
      }
    });
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    await ref.read(kycProvider.notifier).fetchKycStatus();
    if (mounted) {
      setState(() => _isRefreshing = false);
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

    final kycState = ref.watch(kycProvider);
    final status = kycState.verificationStatus;
    final statusResponse = kycState.statusResponse;

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: context.canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: primaryTextColor),
                onPressed: () => context.pop(),
              )
            : null,
        centerTitle: true,
        title: Text(
          'Verification Status',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Status',
            icon: _isRefreshing
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  )
                : Icon(Icons.refresh, color: primaryTextColor),
            onPressed: _isRefreshing ? null : _refresh,
          ),
          IconButton(
            tooltip: 'Sign Out',
            icon: Icon(Icons.logout, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () async {
              await SessionService(context).logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HERO BANNER WITH KYC IMAGE
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: borderColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150.h,
                        color: isDark ? const Color(0xFF151922) : const Color(0xFFFFF7ED),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Image.asset(
                              'assets/promotions/What-is-KYC.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.verified_user_rounded,
                                    size: 64.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.shield_outlined,
                                  size: 20.sp,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Brantro Trust & Safety',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Bank-grade 256-bit identity verification',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // 2. STATUS SUMMARY CARD
              _buildStatusHeaderCard(
                status: status,
                isDark: isDark,
                cardBg: cardBg,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
                message: statusResponse?.message,
                rejectionReason: statusResponse?.rejectionReason,
              ),

              SizedBox(height: 16.h),

              // 3. PROGRESS TIMELINE
              _buildProgressTimeline(
                status: status,
                isDark: isDark,
                cardBg: cardBg,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              SizedBox(height: 16.h),

              // 4. SUBMISSION DETAILS CARD
              _buildSubmissionDetailsCard(
                statusResponse: statusResponse,
                isDark: isDark,
                cardBg: cardBg,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              SizedBox(height: 24.h),

              // 5. ACTION BUTTONS
              _buildActionButtons(
                status: status,
                statusResponse: statusResponse,
                isDark: isDark,
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeaderCard({
    required KycVerificationStatus status,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    String? message,
    String? rejectionReason,
  }) {
    Color badgeColor;
    Color badgeBg;
    String badgeText;
    IconData badgeIcon;
    String title;
    String description;

    switch (status) {
      case KycVerificationStatus.approved:
        badgeColor = const Color(0xFF10B981);
        badgeBg = isDark ? const Color(0xFF064E3B).withOpacity(0.4) : const Color(0xFFD1FAE5);
        badgeText = 'VERIFIED';
        badgeIcon = Icons.check_circle_rounded;
        title = 'Identity Successfully Verified';
        description =
            'Your KYC verification has been approved. You now have full access to business tools, billboard slots, creative orders, and wallet withdrawals.';
        break;

      case KycVerificationStatus.pending:
      case KycVerificationStatus.inReview:
        final isFaceReq = message?.contains('NIN verification completed') == true ||
            message?.contains('FACE_REQUIRED') == true;

        if (isFaceReq) {
          badgeColor = AppColors.primaryColor;
          badgeBg = AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1);
          badgeText = 'SELFIE REQUIRED';
          badgeIcon = Icons.face_rounded;
          title = 'Selfie Verification Needed';
          description =
              'Your National Identity Number was validated successfully. Please take a selfie to match your face and activate your account.';
        } else {
          badgeColor = const Color(0xFFF59E0B);
          badgeBg = isDark ? const Color(0xFF78350F).withOpacity(0.4) : const Color(0xFFFEF3C7);
          badgeText = 'UNDER REVIEW';
          badgeIcon = Icons.hourglass_top_rounded;
          title = 'Documents Under Review';
          description = message != null && message.isNotEmpty
              ? message
              : 'Your verification is being processed with the national identity database. This typically completes within a few moments.';
        }
        break;

      case KycVerificationStatus.rejected:
        badgeColor = const Color(0xFFEF4444);
        badgeBg = isDark ? const Color(0xFF7F1D1D).withOpacity(0.4) : const Color(0xFFFEE2E2);
        badgeText = 'ACTION REQUIRED';
        badgeIcon = Icons.error_rounded;
        title = 'Verification Unsuccessful';
        description = 'We could not verify your identity with the provided details. Please review the reason below and resubmit.';
        break;

      case KycVerificationStatus.notStarted:
      default:
        badgeColor = AppColors.primaryColor;
        badgeBg = AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1);
        badgeText = 'NOT STARTED';
        badgeIcon = Icons.info_outline_rounded;
        title = 'Verification Required';
        description =
            'To protect transactions and comply with financial regulations, please complete your KYC verification.';
        break;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: status == KycVerificationStatus.rejected
              ? const Color(0xFFEF4444).withOpacity(0.3)
              : borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: 14.sp, color: badgeColor),
                    SizedBox(width: 6.w),
                    Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.sp,
              color: secondaryTextColor,
              height: 1.45,
            ),
          ),
          if (status == KycVerificationStatus.rejected &&
              ((rejectionReason != null && rejectionReason.isNotEmpty) ||
                  (message != null && message.isNotEmpty))) ...[
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline_rounded, color: const Color(0xFFEF4444), size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rejection Feedback',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          (rejectionReason != null && rejectionReason.isNotEmpty)
                              ? rejectionReason
                              : message!,
                          style: TextStyle(
                            fontSize: 12.sp,
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
        ],
      ),
    );
  }

  Widget _buildProgressTimeline({
    required KycVerificationStatus status,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    final isSubmitted = status != KycVerificationStatus.notStarted;
    final isApproved = status == KycVerificationStatus.approved;
    final isPending = status == KycVerificationStatus.pending ||
        status == KycVerificationStatus.inReview;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification Roadmap',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildTimelineStep(
            stepNumber: '1',
            title: 'Identity Data Submitted',
            subtitle: isSubmitted ? 'NIN details uploaded' : 'Awaiting submission',
            isComplete: isSubmitted,
            isActive: status == KycVerificationStatus.notStarted,
            isDark: isDark,
            primaryTextColor: primaryTextColor,
            secondaryTextColor: secondaryTextColor,
            isLast: false,
          ),
          _buildTimelineStep(
            stepNumber: '2',
            title: 'Automated Database Check',
            subtitle: isApproved
                ? 'NIMC record match verified'
                : isPending
                    ? 'Processing identity verification'
                    : 'Pending step 1',
            isComplete: isApproved,
            isActive: isPending,
            isDark: isDark,
            primaryTextColor: primaryTextColor,
            secondaryTextColor: secondaryTextColor,
            isLast: false,
          ),
          _buildTimelineStep(
            stepNumber: '3',
            title: 'Account Clearance & Access',
            subtitle: isApproved
                ? 'Full business access unlocked'
                : 'Granted upon verification',
            isComplete: isApproved,
            isActive: false,
            isDark: isDark,
            primaryTextColor: primaryTextColor,
            secondaryTextColor: secondaryTextColor,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String stepNumber,
    required String title,
    required String subtitle,
    required bool isComplete,
    required bool isActive,
    required bool isDark,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required bool isLast,
  }) {
    Color stepColor;
    Widget iconWidget;

    if (isComplete) {
      stepColor = const Color(0xFF10B981);
      iconWidget = Icon(Icons.check, size: 14.sp, color: Colors.white);
    } else if (isActive) {
      stepColor = AppColors.primaryColor;
      iconWidget = SizedBox(
        width: 12.w,
        height: 12.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      stepColor = isDark ? Colors.white24 : const Color(0xFFCBD5E1);
      iconWidget = Text(
        stepNumber,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white54 : const Color(0xFF64748B),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: isComplete || isActive
                    ? stepColor
                    : (isDark ? const Color(0xFF1E232D) : const Color(0xFFF1F5F9)),
                shape: BoxShape.circle,
                border: Border.all(color: stepColor, width: 1.5),
              ),
              child: Center(child: iconWidget),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 28.h,
                color: isComplete
                    ? const Color(0xFF10B981)
                    : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
              ),
          ],
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isComplete || isActive ? primaryTextColor : secondaryTextColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: secondaryTextColor,
                ),
              ),
              if (!isLast) SizedBox(height: 14.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionDetailsCard({
    required dynamic statusResponse,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    final submittedData = statusResponse?.submittedData;
    final submittedDateStr = statusResponse?.submittedAt != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(statusResponse!.submittedAt!)
        : DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.badge_outlined,
                    size: 18.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Submission Summary',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            label: 'Submitted On',
            value: submittedDateStr,
            isDark: isDark,
            primaryTextColor: primaryTextColor,
            secondaryTextColor: secondaryTextColor,
          ),
          if (submittedData != null) ...[
            _buildDetailRow(
              label: 'Document Type',
              value: submittedData.documentType == 'NIN'
                  ? 'National Identity Number (NIN)'
                  : submittedData.documentType == 'CAC'
                      ? 'Corporate Affairs Commission (CAC)'
                      : submittedData.documentType,
              isDark: isDark,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            _buildDetailRow(
              label: 'Document Number',
              value: submittedData.documentNumber.isNotEmpty
                  ? submittedData.documentNumber
                  : 'Submitted on file',
              isDark: isDark,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            if (submittedData.fullName.isNotEmpty)
              _buildDetailRow(
                label: 'Legal Name',
                value: submittedData.fullName,
                isDark: isDark,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),
            if (submittedData.phoneNumber.isNotEmpty)
              _buildDetailRow(
                label: 'Phone Number',
                value: submittedData.phoneNumber,
                isDark: isDark,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),
          ] else ...[
            _buildDetailRow(
              label: 'Identity Document',
              value: 'National Identity Number (NIN)',
              isDark: isDark,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required bool isDark,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required KycVerificationStatus status,
    required dynamic statusResponse,
    required bool isDark,
  }) {
    if (status == KycVerificationStatus.approved) {
      return SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: () => context.go('/dashboard'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Continue to Dashboard →',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Direct selfie CTA if NIN validated but selfie is still required
    final isFaceReq = statusResponse?.status == 'FACE_REQUIRED' ||
        statusResponse?.message?.contains('NIN verification completed') == true ||
        statusResponse?.message?.contains('FACE_REQUIRED') == true;

    if (isFaceReq) {
      final docNum = statusResponse?.documentNumber ??
          statusResponse?.submittedData?.documentNumber ??
          '';

      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/kyc/face', extra: {'documentNumber': docNum}),
              icon: Icon(Icons.camera_alt_rounded, size: 20.sp, color: Colors.white),
              label: Text(
                'Take Selfie Now →',
                style: TextStyle(
                  fontSize: 16.sp,
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
            child: OutlinedButton(
              onPressed: () => context.go('/kyc'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(color: AppColors.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Back to Verification Hub',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (status == KycVerificationStatus.rejected) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () => context.go('/kyc/form'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Resubmit Verification',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: () => context.go('/kyc'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(color: AppColors.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Back to Verification Hub',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (status == KycVerificationStatus.notStarted) {
      return SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: () => context.go('/kyc/form'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Start Verification Now',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Default for Pending / In Review
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () => context.go('/kyc'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Back to Verification Hub',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: TextButton.icon(
            onPressed: _refresh,
            icon: Icon(Icons.refresh, size: 16.sp, color: AppColors.primaryColor),
            label: Text(
              'Check for Status Updates',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
