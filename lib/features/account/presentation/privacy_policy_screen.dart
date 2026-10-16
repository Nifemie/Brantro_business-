import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF12151B) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF12151B) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E232D) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFEAEAEA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Privacy & Data Protection',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Last Updated: August 2026',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.white54 : AppColors.grey500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'At Brantro, we are committed to safeguarding your personal and business data. This Privacy Policy details how we collect, process, and protect your information.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.white70 : AppColors.grey700,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              // Policy Sections
              _buildSection(
                title: '1. Information We Collect',
                content:
                    'We collect personal details (name, email, phone number), identity validation data (NIN, facial biometric snapshots, CAC documentation), and business listing information necessary to facilitate advertising and payments.',
                isDark: isDark,
              ),

              _buildSection(
                title: '2. How We Use Your Data',
                content:
                    'Your data is strictly used for authentication, automated identity verification with certified KYC providers (e.g. Identro), matching ad campaigns, processing payout settlements, and fraud prevention.',
                isDark: isDark,
              ),

              _buildSection(
                title: '3. Data Sharing & Third Parties',
                content:
                    'We do not sell your personal data. We only share required data with verified identity verification partners and payment service gateways strictly to fulfill transactions and regulatory compliance.',
                isDark: isDark,
              ),

              _buildSection(
                title: '4. Data Security & Storage',
                content:
                    'All sensitive information, biometric selfie payloads, and financial records are encrypted using industry-standard TLS encryption in transit and AES-256 at rest.',
                isDark: isDark,
              ),

              _buildSection(
                title: '5. Your Rights & Data Control',
                content:
                    'You have the right to review, update, or request the deletion of your account data by contacting our compliance team at privacy@brantro.com.',
                isDark: isDark,
              ),

              SizedBox(height: 24.h),

              Center(
                child: Text(
                  'Privacy Inquiries: privacy@brantro.com',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white38 : AppColors.grey500,
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E232D) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFEAEAEA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white70 : AppColors.grey700,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
