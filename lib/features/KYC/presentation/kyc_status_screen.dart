import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../logic/kyc_provider.dart';
import 'widgets/kyc_status_badge.dart';

class KycStatusScreen extends ConsumerWidget {
  const KycStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kycState = ref.watch(kycProvider);
    final status = kycState.verificationStatus;
    final statusResponse = kycState.statusResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Verification Status',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            // Status Badge
            KycStatusBadge(
              status: status,
              showDescription: true,
            ),
            SizedBox(height: 32.h),

            // Status Details
            if (statusResponse != null) ...[
              _buildInfoSection(
                'Submission Details',
                [
                  _buildInfoRow(
                    'Submitted On',
                    statusResponse.submittedAt != null
                        ? DateFormat('MMM dd, yyyy - hh:mm a')
                            .format(statusResponse.submittedAt!)
                        : 'N/A',
                  ),
                  if (statusResponse.reviewedAt != null)
                    _buildInfoRow(
                      'Reviewed On',
                      DateFormat('MMM dd, yyyy - hh:mm a')
                          .format(statusResponse.reviewedAt!),
                    ),
                  if (statusResponse.message != null)
                    _buildInfoRow(
                      'Message',
                      statusResponse.message!,
                    ),
                ],
              ),
              SizedBox(height: 24.h),

              // Submitted Information
              if (statusResponse.submittedData != null) ...[
                _buildInfoSection(
                  'Submitted Information',
                  [
                    _buildInfoRow(
                      'Document Type',
                      _formatDocumentType(
                          statusResponse.submittedData!.documentType),
                    ),
                    _buildInfoRow(
                      'Document Number',
                      statusResponse.submittedData!.documentNumber,
                    ),
                    _buildInfoRow(
                      'Full Name',
                      statusResponse.submittedData!.fullName,
                    ),
                    _buildInfoRow(
                      'Phone Number',
                      statusResponse.submittedData!.phoneNumber,
                    ),
                    _buildInfoRow(
                      'Address',
                      statusResponse.submittedData!.address,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ],

            // Status-specific messages
            if (status == KycVerificationStatus.pending ||
                status == KycVerificationStatus.inReview) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.orange[700],
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'What\'s Next?',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[900],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Our team is reviewing your documents. You\'ll receive a notification once the verification is complete. This usually takes 24-48 hours.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.orange[900],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (status == KycVerificationStatus.approved) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Colors.green[700],
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Congratulations! Your account is now verified. You have access to all features.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.green[900],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (status == KycVerificationStatus.rejected) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[700],
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Verification Failed',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[900],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your verification was not successful. Please review the information and resubmit with correct details.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.red[900],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/kyc/form');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Resubmit Verification',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: 32.h),

            // Return to Home Button
            if (status != KycVerificationStatus.rejected)
              OutlinedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Return to Home',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDocumentType(String type) {
    switch (type) {
      case 'NIN':
        return 'National Identity Number';
      case 'DRIVERS_LICENSE':
        return 'Driver\'s License';
      case 'PASSPORT':
        return 'International Passport';
      case 'VOTERS_CARD':
        return 'Voter\'s Card';
      case 'CAC':
        return 'CAC Registration';
      default:
        return type;
    }
  }
}
