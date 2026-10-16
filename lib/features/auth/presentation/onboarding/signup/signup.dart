import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/role_card.dart';
import '../../../../../core/constants/role_information.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String selectedAccountType = 'Personal';
  String selectedRole = 'Advertiser';

  final List<String> roles = [
    'Advertiser',
  ];

  void _showDialog<T>({
    required String title,
    required List<DialogOption<T>> options,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E232D) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(ctx),
                    icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Column(
                    children: options
                        .map(
                          (option) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildDialogOption(option, ctx, isDark),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption<T>(DialogOption<T> option, BuildContext ctx, bool isDark) {
    final isSelected = option.isSelected;
    return GestureDetector(
      onTap: () async {
        if (option.disabled == false) {
          option.onTap();
          // Show selection feedback before closing
          await Future.delayed(const Duration(milliseconds: 300));
          if (ctx.mounted) {
            Navigator.pop(ctx);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: option.disabled == true
              ? (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100)
              : (isDark ? const Color(0xFF12151B) : Colors.white),
          border: Border.all(
            width: 1,
            color: isSelected
                ? (option.activeColor ?? AppColors.primaryColor)
                : (isDark ? Colors.white12 : Colors.grey.shade300),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (option.flag != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? option.activeColor!.withOpacity(0.2)
                      : (isDark ? Colors.white10 : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(option.flag!, style: const TextStyle(fontSize: 18)),
              ),
            if (option.flag != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  if (option.subtitle != null) const SizedBox(height: 6),
                  if (option.subtitle != null)
                    Text(
                      option.subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            Radio<T>(
              value: option.value,
              groupValue: option.groupValue,
              onChanged: (_) {
                if (option.disabled == false) {
                  option.onTap();
                }
              },
              activeColor: option.activeColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountTypeDialog() {
    _showDialog<String>(
      title: 'Choose Account',
      options: [
        DialogOption(
          title: 'Personal',
          subtitle: 'For individuals and everyday needs',
          value: 'PERSONAL',
          groupValue: selectedAccountType,
          activeColor: AppColors.primaryColor,
          onTap: () => setState(() => selectedAccountType = 'Personal'),
        ),
        DialogOption(
          title: 'Business',
          subtitle: 'For organizations and corporate needs',
          value: 'BUSINESS',
          groupValue: selectedAccountType,
          activeColor: AppColors.primaryColor,
          onTap: () => setState(() => selectedAccountType = 'Business'),
        ),
      ],
    );
  }

  void _showRoleDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E232D) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              Flexible(
                child: SingleChildScrollView(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.85,
                    children: roles.map((role) {
                      final roleInfo = ROLE_INFORMATION[role]!;
                      return RoleCard(
                        title: roleInfo.name,
                        description: roleInfo.description,
                        icon: roleInfo.icon,
                        onSelect: () {
                          setState(() => selectedRole = role);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF12151B) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: primaryBg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: primaryBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogoHeader(isDark),
            SizedBox(height: 40.h),
            Text(
              'Create account',
              style: TextStyle(
                fontSize: 28.rsp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select your role to get started',
              style: TextStyle(
                fontSize: 16.rsp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            SizedBox(height: 32.h),

            // Role Selection with Cards
            Text(
              'Select Your Role',
              style: TextStyle(
                fontSize: 14.rsp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
            ),
            SizedBox(height: 16.h),
            // Advertiser Role Card
            GestureDetector(
              onTap: () {
                setState(() => selectedRole = 'Advertiser');
                context.push(
                  '/role-details',
                  extra: {'role': 'Advertiser', 'accountType': selectedAccountType},
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E222B) : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.campaign_rounded,
                        color: AppColors.primaryColor,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Advertiser',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'Buyer',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Book advertising spaces, explore talent, collaborate with creators, and launch campaigns.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.sp,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Provider Notice Callout
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161920) : const Color(0xFFF4F6F9),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        color: isDark ? Colors.orange[300] : Colors.orange[800],
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Looking to Sell or Provide Services?',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'If you are an Artist, Content Producer, Influencer, Screen or Billboard owner, please download and register on the Brantro Business app to manage your listings and bookings.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader(bool isDark) {
    return Row(
      children: [
        Container(
          width: 56.rw,
          height: 56.rh,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.rsp)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.rsp),
            child: Image.asset('assets/icons/launcher.png', fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'Brantro',
          style: TextStyle(
            fontSize: 28.rsp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionTile(String value, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        padding: PlatformResponsive.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.rsp),
        ),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16.rsp, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class DialogOption<T> {
  final String title;
  final String? subtitle;
  final String? flag;
  final T value;
  final T? groupValue;
  final Color? activeColor;
  final bool isSelected;
  final VoidCallback onTap;
  bool disabled;

  DialogOption({
    required this.title,
    this.subtitle,
    this.flag,
    required this.value,
    this.groupValue,
    this.activeColor,
    required this.onTap,
    this.disabled = false,
  }) : isSelected = value == groupValue;
}
