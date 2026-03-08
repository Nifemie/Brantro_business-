import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'widgets/settings_shared_widgets.dart';

class PaymentSettingsScreen extends StatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  State<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends State<PaymentSettingsScreen> {
  bool _autoTopup = false;
  bool _lowBalanceAlert = true;
  bool _biometricPayment = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E2329)
          : AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(
              title: 'PAYMENT SETTINGS',
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Payment Security ───
                    const SettingsSectionHeader(title: 'Payment Security'),
                    SettingsCard(
                      children: [
                        SettingsNavTile(
                          icon: Icons.dialpad_outlined,
                          title: 'Payment PIN',
                          subtitle: 'Change or reset your transaction PIN',
                          onTap: () {},
                        ),
                        const SettingsDivider(),
                        SettingsSwitchTile(
                          icon: Icons.fingerprint,
                          title: 'Biometric Transaction',
                          subtitle:
                              'Authorize payments with FaceID/Fingerprint',
                          value: _biometricPayment,
                          onChanged: (val) {
                            HapticFeedback.lightImpact();
                            setState(() => _biometricPayment = val);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // ─── Methods ───
                    const SettingsSectionHeader(title: 'Payout & Funding'),
                    SettingsCard(
                      children: [
                        SettingsNavTile(
                          icon: Icons.account_balance_outlined,
                          title: 'Linked Bank Accounts',
                          subtitle: 'Manage destinations for your withdrawals',
                          onTap: () {},
                        ),
                        const SettingsDivider(),
                        SettingsNavTile(
                          icon: Icons.credit_card_outlined,
                          title: 'Saved Cards',
                          subtitle: 'Manage funding sources for ad slots',
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // ─── Automation ───
                    const SettingsSectionHeader(title: 'Smart Management'),
                    SettingsCard(
                      children: [
                        SettingsSwitchTile(
                          icon: Icons.notifications_active_outlined,
                          title: 'Low Balance Alert',
                          subtitle: 'Notify me when balance is below ₦10,000',
                          value: _lowBalanceAlert,
                          onChanged: (val) =>
                              setState(() => _lowBalanceAlert = val),
                        ),
                        const SettingsDivider(),
                        SettingsSwitchTile(
                          icon: Icons.restart_alt_rounded,
                          title: 'Auto-Topup',
                          subtitle: 'Keep your ad campaigns running always',
                          value: _autoTopup,
                          onChanged: (val) => setState(() => _autoTopup = val),
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
