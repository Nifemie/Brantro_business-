import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../account/logic/profile_provider.dart';
import '../../../account/logic/persona_provider.dart';

class PersonaSwitcherPill extends ConsumerWidget {
  const PersonaSwitcherPill({super.key});

  IconData _getPersonaIcon(String? role) {
    if (role == null || role.toUpperCase() == 'ALL') return Icons.public_rounded;
    switch (role.toUpperCase()) {
      case 'HOST':
        return Icons.business_rounded;
      case 'INFLUENCER':
      case 'UGC_CREATOR':
        return Icons.person_pin_rounded;
      case 'CREATOR':
      case 'CREATIVE':
      case 'DESIGNER':
        return Icons.palette_rounded;
      case 'ARTIST':
      case 'PRODUCER':
        return Icons.music_note_rounded;
      case 'TV_STATION':
      case 'RADIO_STATION':
      case 'MEDIA_HOUSE':
        return Icons.cell_tower_rounded;
      default:
        return Icons.work_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profileData = ref.watch(profileHeaderProvider).value;

    final roles = profileData?.roles ?? [];
    if (roles.length <= 1) {
      // Hidden if user has 1 role or no roles
      return const SizedBox.shrink();
    }

    final activePersona = ref.watch(activePersonaProvider);
    final displayText = PersonaHelper.formatPersonaName(activePersona);
    final currentIcon = _getPersonaIcon(activePersona);

    return GestureDetector(
      onTap: () => _showPersonaSwitcherSheet(context, ref, roles, activePersona),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        margin: EdgeInsets.only(right: 6.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2E39) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.12) : const Color(0xFFCBD5E1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              currentIcon,
              size: 14.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 5.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 90.w),
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14.sp,
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }

  void _showPersonaSwitcherSheet(
    BuildContext context,
    WidgetRef ref,
    List<String> roles,
    String? currentActive,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E232D) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded, color: AppColors.primaryColor, size: 22.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Switch Workspace Persona',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'Select a persona to filter your dashboard tools, or view everything at once.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(color: isDark ? Colors.white10 : Colors.grey[200]),
                SizedBox(height: 8.h),

                // Option: All Personas (Unified Mode)
                _buildRoleOption(
                  context: context,
                  title: 'All Personas (Unified)',
                  subtitle: 'Show all tools and inventory together',
                  icon: Icons.public_rounded,
                  isSelected: currentActive == null,
                  onTap: () {
                    ref.read(activePersonaProvider.notifier).state = null;
                    Navigator.pop(context);
                  },
                  isDark: isDark,
                ),

                // Individual Roles
                ...roles.map((role) {
                  final formattedTitle = PersonaHelper.formatPersonaName(role);
                  final icon = _getPersonaIcon(role);
                  final isSelected = currentActive?.toUpperCase() == role.toUpperCase();

                  return _buildRoleOption(
                    context: context,
                    title: formattedTitle,
                    subtitle: 'Focus strictly on $formattedTitle workspace',
                    icon: icon,
                    isSelected: isSelected,
                    onTap: () {
                      ref.read(activePersonaProvider.notifier).state = role.toUpperCase();
                      Navigator.pop(context);
                    },
                    isDark: isDark,
                  );
                }),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor.withOpacity(0.12)
            : (isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : (isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0)),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor
                : (isDark ? Colors.white10 : Colors.grey[200]),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.grey[700]),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11.sp,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: AppColors.primaryColor, size: 20.sp)
            : null,
      ),
    );
  }
}
