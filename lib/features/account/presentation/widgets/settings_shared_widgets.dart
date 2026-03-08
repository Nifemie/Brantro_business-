import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';

/// Section header label used across all settings sections.
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 8.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: isDark ? Colors.white54 : AppColors.grey500,
        ),
      ),
    );
  }
}

/// Card container that wraps a group of settings tiles.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2F36) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

/// A tappable settings row with icon, title, subtitle, and chevron.
class SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsNavTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            _iconBox(icon, isDark),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _titleStyle(isDark)),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: _subtitleStyle(isDark)),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white24 : AppColors.grey400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// A settings row with a toggle switch.
class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            _iconBox(icon, isDark),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _titleStyle(isDark)),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: _subtitleStyle(isDark)),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Switch.adaptive(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: AppColors.primaryColor,
              activeTrackColor: AppColors.primaryColor.withOpacity(0.3),
              inactiveThumbColor: isDark ? Colors.grey[600] : AppColors.grey400,
              inactiveTrackColor: isDark ? Colors.grey[800] : AppColors.grey200,
            ),
          ],
        ),
      ),
    );
  }
}

/// A read-only info row (e.g. App Version).
class SettingsInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SettingsInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          _iconBox(icon, isDark),
          SizedBox(width: 14.w),
          Expanded(child: Text(title, style: _titleStyle(isDark))),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white54 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin divider used between tiles inside a [SettingsCard].
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: isDark ? Colors.white10 : AppColors.grey200,
      ),
    );
  }
}

// ─── Shared helpers ─────────────────────────────────────────────

Widget _iconBox(IconData icon, bool isDark) {
  return Container(
    width: 40.w,
    height: 40.w,
    decoration: BoxDecoration(
      color: AppColors.primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
  );
}

TextStyle _titleStyle(bool isDark) => TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.w500,
  color: isDark ? Colors.white : AppColors.textPrimary,
);

TextStyle _subtitleStyle(bool isDark) => TextStyle(
  fontSize: 12.sp,
  color: isDark ? Colors.white38 : AppColors.grey500,
);
