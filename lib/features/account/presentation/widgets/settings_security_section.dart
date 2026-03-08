import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import 'settings_shared_widgets.dart';

class SecuritySettingsSection extends StatefulWidget {
  const SecuritySettingsSection({super.key});

  @override
  State<SecuritySettingsSection> createState() =>
      _SecuritySettingsSectionState();
}

class _SecuritySettingsSectionState extends State<SecuritySettingsSection> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Security'),
        SettingsCard(
          children: [
            SettingsNavTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () => _showChangePasswordDialog(),
            ),
            const SettingsDivider(),
            SettingsSwitchTile(
              icon: Icons.security_outlined,
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security',
              value: _twoFactorEnabled,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _twoFactorEnabled = value);
                // TODO: Implement 2FA setup flow
              },
            ),
            const SettingsDivider(),
            SettingsSwitchTile(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face ID',
              value: _biometricEnabled,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _biometricEnabled = value);
                // TODO: Implement biometric setup
              },
            ),
            const SettingsDivider(),
            SettingsNavTile(
              icon: Icons.timer_outlined,
              title: 'Session Timeout',
              subtitle: 'Auto-logout after inactivity',
              onTap: () {
                // TODO: Navigate to session timeout settings
              },
            ),
            const SettingsDivider(),
            SettingsNavTile(
              icon: Icons.devices_outlined,
              title: 'Active Sessions',
              subtitle: 'Manage your logged-in devices',
              onTap: () {
                // TODO: Navigate to active sessions
              },
            ),
          ],
        ),
      ],
    );
  }

  // ─── Change Password Dialog ──────────────────────────────────
  void _showChangePasswordDialog() {
    final currentPwCtrl = TextEditingController();
    final newPwCtrl = TextEditingController();
    final confirmPwCtrl = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF2A2F36) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Text('Change Password', style: AppTexts.h3()),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _pwField(
                    currentPwCtrl,
                    'Current Password',
                    obscureCurrent,
                    () {
                      setDialogState(() => obscureCurrent = !obscureCurrent);
                    },
                  ),
                  SizedBox(height: 16.h),
                  _pwField(newPwCtrl, 'New Password', obscureNew, () {
                    setDialogState(() => obscureNew = !obscureNew);
                  }),
                  SizedBox(height: 16.h),
                  _pwField(
                    confirmPwCtrl,
                    'Confirm New Password',
                    obscureConfirm,
                    () {
                      setDialogState(() => obscureConfirm = !obscureConfirm);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => ctx.pop(),
                child: Text(
                  'Cancel',
                  style: AppTexts.buttonSmall(color: AppColors.grey600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (newPwCtrl.text == confirmPwCtrl.text) {
                    ctx.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Password changed successfully'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Passwords do not match'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text('Change Password', style: AppTexts.buttonSmall()),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pwField(
    TextEditingController ctrl,
    String label,
    bool obscure,
    VoidCallback onToggle,
  ) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTexts.bodyMedium(color: AppColors.grey600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.grey600,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
