import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/app_button.dart';
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
    'Artist',
    'Screen / Billboard',
    'Content Producer',
    'Influencer',
    'UGC Creator',
    'Host',
    'TV Station',
    'Radio Station',
    'Media House',
    'Designer',
    'Talent Manager',
  ];

  void _showDialog<T>({
    required String title,
    required List<DialogOption<T>> options,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
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
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
                            child: _buildDialogOption(option, ctx),
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

  Widget _buildDialogOption<T>(DialogOption<T> option, BuildContext ctx) {
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
          color: option.disabled == true ? Colors.grey.shade100 : Colors.white,
          border: Border.all(
            width: 1,
            color: isSelected
                ? (option.activeColor ?? AppColors.primaryColor)
                : Colors.grey.shade300,
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
                      : Colors.grey.shade100,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (option.subtitle != null) const SizedBox(height: 6),
                  if (option.subtitle != null)
                    Text(
                      option.subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
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
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                  color: Colors.black87,
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogoHeader(),
            SizedBox(height: 40.h),
            Text(
              'Create account',
              style: TextStyle(fontSize: 28.rsp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select your role to get started',
              style: TextStyle(fontSize: 16.rsp, color: Colors.grey[600]),
            ),
            SizedBox(height: 32.h),

            // Role Selection with Cards
            Text(
              'Select Your Role',
              style: TextStyle(
                fontSize: 14.rsp,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.h),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.0,
              children: roles.map((role) {
                final roleInfo = ROLE_INFORMATION[role]!;
                final isSelected = selectedRole == role;
                return GestureDetector(
                  onTap: () => setState(() => selectedRole = role),
                  child: RoleCard(
                    title: roleInfo.name,
                    description: roleInfo.description,
                    icon: roleInfo.icon,
                    onSelect: () => setState(() => selectedRole = role),
                    isSelected: isSelected,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  // Determine navigation based on role and account type
                  final isIndividualAdvertiser =
                      selectedRole == 'Advertiser' &&
                      selectedAccountType.toLowerCase().contains('personal');

                  if (isIndividualAdvertiser) {
                    // Skip role details and go directly to account details
                    context.push(
                      '/account-details',
                      extra: {
                        'role': selectedRole,
                        'accountType': selectedAccountType,
                        'roleData':
                            {}, // Empty role data for individual advertiser
                      },
                    );
                  } else {
                    // Go to role details first
                    context.push(
                      '/role-details',
                      extra: {
                        'role': selectedRole,
                        'accountType': selectedAccountType,
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.rsp),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16.rsp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
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
          style: TextStyle(fontSize: 28.rsp, fontWeight: FontWeight.bold),
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
