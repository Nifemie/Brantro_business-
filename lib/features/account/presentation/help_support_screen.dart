import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/re_useable/app_color.dart';
import 'widgets/support/support_components.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
        ),
        title: Text(
          'Help & Support',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // Contact Us Section
              SupportSection(
                title: 'Contact Us',
                children: [
                  SupportMenuItem(
                    icon: Icons.edit_note_rounded,
                    title: 'Contact Support Form',
                    subtitle: 'Send an inquiry or report an issue',
                    iconColor: AppColors.primaryColor,
                    iconContainerColor: AppColors.primaryColor.withOpacity(0.1),
                    onTap: () => context.push('/contact-us'),
                  ),
                  _buildDivider(isDark),
                  SupportMenuItem(
                    icon: Icons.email_outlined,
                    title: 'Email Us',
                    subtitle: 'support@brantro.com',
                    iconColor: const Color(0xFF3B82F6),
                    iconContainerColor: const Color(0xFF3B82F6).withOpacity(0.1),
                    onTap: () => _launchEmail(context, 'support@brantro.com'),
                  ),
                  _buildDivider(isDark),
                  SupportMenuItem(
                    icon: Icons.phone_in_talk_outlined,
                    title: 'Call Us',
                    subtitle: '+234 800 123 4567',
                    iconColor: const Color(0xFF10B981),
                    iconContainerColor: const Color(0xFF10B981).withOpacity(0.1),
                    onTap: () => _launchPhone(context, '+2348001234567'),
                  ),
                  _buildDivider(isDark),
                  SupportMenuItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'WhatsApp Support',
                    subtitle: 'Chat directly with our support team',
                    iconColor: const Color(0xFF25D366),
                    iconContainerColor: const Color(0xFF25D366).withOpacity(0.1),
                    onTap: () => _launchWhatsApp(context, '+2348001234567'),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Quick Help Section
              SupportSection(
                title: 'Quick Help & FAQs',
                children: [
                  SupportMenuItem(
                    icon: Icons.quiz_outlined,
                    title: 'Frequently Asked Questions',
                    subtitle: 'Quick answers for slots, bookings & KYC',
                    iconColor: const Color(0xFFF59E0B),
                    iconContainerColor: const Color(0xFFF59E0B).withOpacity(0.1),
                    onTap: () => context.push('/faq'),
                  ),
                  _buildDivider(isDark),
                  SupportMenuItem(
                    icon: Icons.support_agent_rounded,
                    title: 'Live Chat',
                    subtitle: 'Instant messaging with a support rep',
                    iconColor: const Color(0xFF8B5CF6),
                    iconContainerColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                    onTap: () => _showComingSoonDialog(context, 'Live Chat'),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Legal Section
              SupportSection(
                title: 'Legal & Compliance',
                children: [
                  SupportMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Read our platform policies & terms',
                    iconColor: const Color(0xFF6366F1),
                    iconContainerColor: const Color(0xFF6366F1).withOpacity(0.1),
                    onTap: () => context.push('/terms-of-service'),
                  ),
                  _buildDivider(isDark),
                  SupportMenuItem(
                    icon: Icons.shield_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'How we manage and protect your data',
                    iconColor: const Color(0xFF06B6D4),
                    iconContainerColor: const Color(0xFF06B6D4).withOpacity(0.1),
                    onTap: () => context.push('/privacy-policy'),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // App Version
              Center(
                child: Column(
                  children: [
                    Text(
                      'Brantro Business',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white38 : AppColors.grey500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white24 : AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Brantro Business Support Request',
      },
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw Exception('Could not launch email');
      }
    } catch (_) {
      // Fallback: Copy to clipboard and notify user
      await Clipboard.setData(ClipboardData(text: email));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Support email copied to clipboard: $email'),
            backgroundColor: AppColors.primaryColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _launchPhone(BuildContext context, String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    try {
      final launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw Exception('Could not launch dialer');
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: phone));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number copied: $phone'),
            backgroundColor: AppColors.primaryColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String phone) async {
    final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');
    try {
      final launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: phone));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WhatsApp number copied: $phone'),
            backgroundColor: AppColors.primaryColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E232D) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        content: Text(
          '$feature will be available in the next update!',
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? Colors.white70 : AppColors.grey700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
