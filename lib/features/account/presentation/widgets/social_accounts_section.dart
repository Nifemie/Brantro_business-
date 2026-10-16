import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/service/session_service.dart';
import '../../../../core/data/data_state.dart';
import '../../logic/social_account_provider.dart';
import '../../data/models/social_account_model.dart';
import 'add_social_account_dialog.dart';

class SocialAccountsSection extends ConsumerStatefulWidget {
  const SocialAccountsSection({super.key});

  @override
  ConsumerState<SocialAccountsSection> createState() => _SocialAccountsSectionState();
}

class _SocialAccountsSectionState extends ConsumerState<SocialAccountsSection> {
  String _alias = 'abis';

  @override
  void initState() {
    super.initState();
    _loadUserAlias();
  }

  Future<void> _loadUserAlias() async {
    try {
      final user = await SessionService.getUser();
      if (user != null && user['alias'] != null && user['alias'].toString().isNotEmpty) {
        if (mounted) {
          setState(() {
            _alias = user['alias'];
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final socialState = ref.watch(socialAccountProvider);
    final accounts = socialState.data ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : AppColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title and + Add Account Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Social Media Accounts',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primaryColor,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddSocialAccountDialog(
                      onSubmit: ({
                        required String platform,
                        required String username,
                        required String profileUrl,
                        required int followersCount,
                        required bool isPrimary,
                        required bool isActive,
                      }) async {
                        // Normalize 'Twitter/X' dropdown value to API expected platform string
                        final apiPlatform = platform == 'Twitter/X' ? 'Twitter' : platform;

                        try {
                          await ref.read(socialAccountProvider.notifier).addSocialAccount(
                            platform: apiPlatform,
                            handle: username,
                            profileUrl: profileUrl,
                            followers: followersCount,
                            isPrimary: isPrimary,
                            isActive: isActive,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Successfully linked $platform account: $username'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString().replaceAll('Exception: ', '')),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16.sp,
                ),
                label: Text(
                  'Add Account',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Horizontal Row of linked social account circles
          if (accounts.isNotEmpty) ...[
            Row(
              children: accounts.map((account) {
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: _buildSocialCircle(
                    platform: account.platform,
                    isDark: isDark,
                    isPrimary: account.isPrimary,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? Colors.grey[800] : AppColors.grey200,
            ),
            SizedBox(height: 16.h),
          ],

          // Cards list
          if (socialState.isInitialLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            )
          else if (accounts.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 48.sp,
                      color: isDark ? Colors.white24 : Colors.grey[300],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'No social media accounts linked yet',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.white54 : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accounts.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final account = accounts[index];
                return _buildAccountCard(
                  account: account,
                  isDark: isDark,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSocialCircle({
    required String platform,
    required bool isDark,
    bool isPrimary = false,
  }) {
    Color platformColor = Colors.grey;
    Widget logo = const Icon(Icons.share, color: Colors.white, size: 16);

    final normalizedPlatform = platform.toLowerCase();
    if (normalizedPlatform.contains('facebook')) {
      platformColor = const Color(0xFF1877F2);
      logo = Text(
        'f',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 22.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      );
    } else if (normalizedPlatform.contains('twitter') || normalizedPlatform.contains('x')) {
      platformColor = const Color(0xFF0F1419);
      logo = Text(
        'X',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      );
    } else if (normalizedPlatform.contains('instagram')) {
      platformColor = const Color(0xFFE1306C);
      logo = Icon(Icons.camera_alt, color: Colors.white, size: 18.sp);
    } else if (normalizedPlatform.contains('tiktok')) {
      platformColor = const Color(0xFF010101);
      logo = SvgPicture.string(
        '<svg viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M9 12a4 4 0 1 0 4 4V4a5 5 0 0 0 5 5"></path></svg>',
        width: 18.w,
        height: 18.h,
      );
    } else if (normalizedPlatform.contains('youtube')) {
      platformColor = const Color(0xFFFF0000);
      logo = Icon(Icons.play_arrow, color: Colors.white, size: 20.sp);
    } else if (normalizedPlatform.contains('linkedin')) {
      platformColor = const Color(0xFF0077B5);
      logo = Text(
        'in',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }

    final Widget circle = Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: platformColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: platformColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: logo),
    );

    if (isPrimary) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          circle,
          Positioned(
            top: -2.h,
            right: -2.w,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFFB300),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star,
                color: Colors.white,
                size: 10.sp,
              ),
            ),
          ),
        ],
      );
    }

    return circle;
  }

  Widget _buildAccountCard({
    required SocialAccountModel account,
    required bool isDark,
  }) {
    // Format follower numbers (e.g. 1500 -> 1.5K)
    String followersText = '${account.followers} followers';
    if (account.followers >= 1000000) {
      followersText = '${(account.followers / 1000000).toStringAsFixed(1)}M followers';
    } else if (account.followers >= 1000) {
      followersText = '${(account.followers / 1000).toStringAsFixed(1)}K followers';
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF262626) : const Color(0xFFFCFCFD),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : const Color(0xFFEBEAED),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildSocialCircle(
            platform: account.platform,
            isDark: isDark,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      account.platform,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    if (account.isPrimary) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Primary',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  account.handle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white70 : AppColors.grey600,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    SvgPicture.string(
                      '<svg viewBox="0 0 24 24" fill="none" stroke="#FF6C2F" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>',
                      width: 14.w,
                      height: 14.h,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        followersText,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : AppColors.grey700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action buttons: Visit URL and Delete
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Social Account'),
                      content: Text('Are you sure you want to remove your ${account.platform} account (${account.handle})?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(foregroundColor: AppColors.error),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      await ref.read(socialAccountProvider.notifier).deleteSocialAccount(account.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Social account removed successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString().replaceAll('Exception: ', '')),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  }
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 20.sp,
                ),
                tooltip: 'Delete Account',
              ),
              SizedBox(width: 4.w),
              InkWell(
                onTap: () => _launchUrl(account.profileUrl),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.secondaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_new,
                        color: AppColors.secondaryColor,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Visit',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
