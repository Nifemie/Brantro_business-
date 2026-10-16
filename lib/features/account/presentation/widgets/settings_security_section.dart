import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'settings_shared_widgets.dart';

class SecuritySettingsSection extends StatelessWidget {
  const SecuritySettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Security & Account'),
        SettingsCard(
          children: [
            SettingsNavTile(
              icon: Icons.lock_reset_rounded,
              title: 'Change Password',
              subtitle: 'Reset and update your account password',
              onTap: () {
                context.push('/forgot-password');
              },
            ),
          ],
        ),
      ],
    );
  }
}
