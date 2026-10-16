import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/ad_slot_details/basic_information_card.dart';
import '../widgets/ad_slot_details/pricing_duration_card.dart';
import '../widgets/ad_slot_details/audience_coverage_card.dart';
import '../widgets/ad_slot_details/content_requirements_card.dart';

class AdSlotDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> adSlot;

  const AdSlotDetailsScreen({
    super.key,
    required this.adSlot,
  });

  String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final name = adSlot['name'] ?? 'Premium Influencer Brand Promotion';
    
    final rawDescription = adSlot['description'] ?? 'Promote your brand, product, service, or event through influencer marketing with high audience engagement across social media platforms. This package includes branded content creation, audience interaction, and multi-platform promotion to maximize visibility and reach.';
    final description = _stripHtmlIfNeeded(rawDescription);

    final tags = (adSlot['features'] as List?)?.map((e) => e.toString()).toList() ?? 
                 ['Content Boosting (Paid Ads)', 'Cross Posting (Multiple Platforms)', 'Niche Targeting'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(
              title: 'AD SLOT DETAILS',
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 800.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Tags
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: tags.map((tag) => _buildTag(tag)).toList(),
                        ),
                        SizedBox(height: 16.h),
                        
                        // Description
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white70 : Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Cards Component Widgets
                        BasicInformationCard(adSlot: adSlot, isDark: isDark),
                        SizedBox(height: 24.h),
                        PricingDurationCard(adSlot: adSlot, isDark: isDark),
                        SizedBox(height: 24.h),
                        AudienceCoverageCard(adSlot: adSlot, isDark: isDark),
                        SizedBox(height: 24.h),
                        ContentRequirementsCard(adSlot: adSlot, isDark: isDark),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7F5), // Light cyan/green
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF0D9488), // Teal
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
