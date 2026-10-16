import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
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
                      'Brantro Business Terms & Conditions',
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
                      'Welcome to Brantro Business. By registering, listing, booking, or using our advertising inventory management platform, you agree to comply with and be bound by the following terms.',
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

              // Terms Sections
              _buildSection(
                title: '1. Account & Identity Verification',
                content:
                    'To publish advertisement slots, offer creative services, or receive wallet payouts, partners and creators must complete identity verification (NIN / Face Match / CAC for corporate entities). You are responsible for maintaining the confidentiality of your account credentials.',
                isDark: isDark,
              ),

              _buildSection(
                title: '2. Advertisement Inventory & Listings',
                content:
                    'Media owners, influencers, and artists agree that all listed advertisement inventory (billboards, screens, walls, social media slots) must accurately represent available locations, audience metrics, and pricing. Brantro reserves the right to review and remove inaccurate or misleading listings.',
                isDark: isDark,
              ),

              _buildSection(
                title: '3. Booking Orders & Fulfillment',
                content:
                    'Once a booking order is placed and confirmed, partners agree to fulfill the campaign specifications within the designated time window and agreed duration. Proof of execution (media impressions, campaign photos, or broadcast recordings) must be provided upon request.',
                isDark: isDark,
              ),

              _buildSection(
                title: '4. Fees, Payments & Escrow',
                content:
                    'Funds from campaign bookings are held securely in escrow until milestones or campaign deliveries are completed. Applicable platform commission fees are automatically deducted upon final settlement and payout disbursement.',
                isDark: isDark,
              ),

              _buildSection(
                title: '5. Prohibited Content',
                content:
                    'Advertisements and campaigns must not violate applicable advertising standards, local regulations, or promote illegal substances, hate speech, defamation, or fraudulent schemes.',
                isDark: isDark,
              ),

              _buildSection(
                title: '6. Termination & Suspension',
                content:
                    'Brantro reserves the right to suspend or terminate accounts that breach these terms, commit fraud, or fail verification standards.',
                isDark: isDark,
              ),

              SizedBox(height: 24.h),

              Center(
                child: Text(
                  'Questions? Contact support@brantro.com',
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
