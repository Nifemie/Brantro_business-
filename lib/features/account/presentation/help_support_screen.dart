import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import 'widgets/support/support_components.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: AppTexts.h3(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Contact Us Section
            SupportSection(
              title: 'Contact Us',
              children: [
                SupportMenuItem(
                  icon: Icons.edit_outlined,
                  title: 'Submit a Report',
                  subtitle: 'Fill out our contact form',
                  iconColor: AppColors.primaryColor,
                  iconContainerColor: AppColors.primaryColor.withOpacity(0.1),
                  onTap: () => context.push('/contact-us'),
                ),
                _buildDivider(),
                SupportMenuItem(
                  icon: Icons.email_outlined,
                  title: 'Email Us',
                  subtitle: 'support@brantro.com',
                  iconColor: AppColors.primaryColor,
                  iconContainerColor: AppColors.primaryColor.withOpacity(0.1),
                  onTap: () => _launchEmail('support@brantro.com'),
                ),
                _buildDivider(),
                SupportMenuItem(
                  icon: Icons.phone_outlined,
                  title: 'Call Us',
                  subtitle: '+234 800 123 4567',
                  iconColor: AppColors.primaryColor,
                  iconContainerColor: AppColors.primaryColor.withOpacity(0.1),
                  onTap: () => _launchPhone('+2348001234567'),
                ),
                _buildDivider(),
                SupportMenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'WhatsApp',
                  subtitle: 'Chat with us on WhatsApp',
                  iconColor: AppColors.primaryColor,
                  iconContainerColor: AppColors.primaryColor.withOpacity(0.1),
                  onTap: () => _launchWhatsApp('+2348001234567'),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Quick Help Section
            SupportSection(
              title: 'Quick Help',
              children: [
                SupportMenuItem(
                  icon: Icons.chat_outlined,
                  title: 'Live Chat',
                  subtitle: 'Chat with our support team',
                  onTap: () {
                    // TODO: Implement live chat
                    _showComingSoonDialog(context, 'Live Chat');
                  },
                ),
                _buildDivider(),
                SupportMenuItem(
                  icon: Icons.question_answer_outlined,
                  title: 'FAQs',
                  subtitle: 'Find answers to common questions',
                  onTap: () {
                    // TODO: Navigate to FAQs screen
                    _showComingSoonDialog(context, 'FAQs');
                  },
                ),
                _buildDivider(),
                SupportMenuItem(
                  icon: Icons.report_problem_outlined,
                  title: 'Report a Problem',
                  subtitle: 'Let us know if something is wrong',
                  onTap: () {
                    // TODO: Navigate to Report Problem screen
                    _showComingSoonDialog(context, 'Report a Problem');
                  },
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Resources Section
            SupportSection(
              title: 'Resources',
              children: [
                SupportMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Browse our help articles',
                  onTap: () {
                    // TODO: Navigate to Help Center
                    _showComingSoonDialog(context, 'Help Center');
                  },
                ),
                _buildDivider(),
                SupportMenuItem(
                  icon: Icons.video_library_outlined,
                  title: 'Video Tutorials',
                  subtitle: 'Learn how to use Brantro',
                  onTap: () {
                    // TODO: Navigate to Video Tutorials
                    _showComingSoonDialog(context, 'Video Tutorials');
                  },
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Legal Section
            SupportSection(
              title: 'Legal',
              children: [
                SupportMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () {
                    // TODO: Navigate to Terms of Service
                    _showComingSoonDialog(context, 'Terms of Service');
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // App Version
            Center(
              child: Column(
                children: [
                  Text(
                    'Brantro',
                    style: AppTexts.labelMedium(color: AppColors.grey500),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Version 1.0.0',
                    style: AppTexts.bodySmall(color: AppColors.grey400),
                  ),
                ],
              ),
            ),

            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(height: 1, thickness: 1, color: AppColors.grey200),
    );
  }

  // Launch email
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  // Launch phone
  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  // Launch WhatsApp
  Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  // Show coming soon dialog
  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Coming Soon',
          style: AppTexts.h3(color: AppColors.textPrimary),
        ),
        content: Text(
          '$feature will be available soon!',
          style: AppTexts.bodyMedium(color: AppColors.grey700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: AppTexts.labelMedium(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
