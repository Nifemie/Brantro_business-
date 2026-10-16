import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import 'settings_shared_widgets.dart';

class PrivacyAppearanceAboutSection extends ConsumerWidget {
  const PrivacyAppearanceAboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Appearance ───
        const SettingsSectionHeader(title: 'Appearance'),
        SettingsCard(
          children: [
            SettingsSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Switch between light and dark theme',
              value: isDarkMode,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // ─── About & Legal ───
        const SettingsSectionHeader(title: 'About & Legal'),
        SettingsCard(
          children: [
            SettingsNavTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'Get assistance and browse FAQs',
              onTap: () {
                context.push('/help-support');
              },
            ),
            const SettingsDivider(),
            SettingsNavTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our platform policies & terms',
              onTap: () {
                context.push('/terms-of-service');
              },
            ),
            const SettingsDivider(),
            SettingsNavTile(
              icon: Icons.shield_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we manage and protect your data',
              onTap: () {
                context.push('/privacy-policy');
              },
            ),
            const SettingsDivider(),
            const SettingsInfoTile(
              icon: Icons.info_outline_rounded,
              title: 'App Version',
              value: 'v1.0.0',
            ),
          ],
        ),
      ],
    );
  }
}
