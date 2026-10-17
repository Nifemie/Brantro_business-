import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
  String? selectedRole;

  final List<String> roles = [
    'Artist',
    'Content Producer',
    'Influencer',
    'UGC Creator',
    'Host',
    'TV Station',
    'Radio Station',
    'Media House',
    'Creatives',
    'Designer',
    'Talent Manager',
    'Screen / Billboard',
  ];

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
              'Select your seller or creator role to get started',
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

            // Grid of Business Seller Roles
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.85,
              children: roles.map((role) {
                final roleInfo = ROLE_INFORMATION[role] ??
                    RoleInfo(name: role, description: '', icon: Icons.work_outline);
                final isSelected = selectedRole == role;
                return RoleCard(
                  title: roleInfo.name,
                  description: roleInfo.description,
                  icon: roleInfo.icon,
                  isSelected: isSelected,
                  onSelect: () {
                    setState(() => selectedRole = role);
                    context.push(
                      '/role-details',
                      extra: {
                        'role': role,
                        'accountType': selectedAccountType,
                      },
                    );
                  },
                );
              }).toList(),
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
}
