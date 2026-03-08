import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'settings_shared_widgets.dart';

class PrivacyAppearanceAboutSection extends StatefulWidget {
  const PrivacyAppearanceAboutSection({super.key});

  @override
  State<PrivacyAppearanceAboutSection> createState() =>
      _PrivacyAppearanceAboutSectionState();
}

class _PrivacyAppearanceAboutSectionState
    extends State<PrivacyAppearanceAboutSection> {
  // Appearance
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
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
              value: _isDarkMode,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _isDarkMode = value);
                // TODO: Implement theme switching
              },
            ),
            const SettingsDivider(),
            SettingsNavTile(
              icon: Icons.language_outlined,
              title: 'Content Language',
              subtitle: 'English',
              onTap: () {
                // TODO: Language selector
              },
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // ─── About & Legal ───
        const SettingsSectionHeader(title: 'About'),
        SettingsCard(
          children: [
            SettingsNavTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get assistance and FAQs',
              onTap: () {
                context.push('/help-support');
              },
            ),
            const SettingsDivider(),
            SettingsNavTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms',
              onTap: () {
                // TODO: Navigate to Terms of Service
              },
            ),

            const SettingsDivider(),
            const SettingsInfoTile(
              icon: Icons.info_outline,
              title: 'App Version',
              value: 'v1.0.0',
            ),
          ],
        ),
      ],
    );
  }
}
