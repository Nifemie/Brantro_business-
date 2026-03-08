import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_shared_widgets.dart';

class NotificationSettingsSection extends StatefulWidget {
  const NotificationSettingsSection({super.key});

  @override
  State<NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends State<NotificationSettingsSection> {
  bool _pushEnabled = true;
  bool _orderUpdates = true;
  bool _campaignAlerts = true;
  bool _paymentAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Notifications'),
        SettingsCard(
          children: [
            SettingsSwitchTile(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: _pushEnabled,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _pushEnabled = value);
                // TODO: Update notification preference
              },
            ),
            const SettingsDivider(),
            SettingsSwitchTile(
              icon: Icons.shopping_bag_outlined,
              title: 'Order Updates',
              subtitle: 'Status changes on your orders',
              value: _orderUpdates,
              enabled: _pushEnabled,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _orderUpdates = value);
              },
            ),
            const SettingsDivider(),
            SettingsSwitchTile(
              icon: Icons.campaign_outlined,
              title: 'Campaign Alerts',
              subtitle: 'Ad campaign performance & updates',
              value: _campaignAlerts,
              enabled: _pushEnabled,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _campaignAlerts = value);
              },
            ),
            const SettingsDivider(),
            SettingsSwitchTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Payment Alerts',
              subtitle: 'Incoming & outgoing payments',
              value: _paymentAlerts,
              enabled: _pushEnabled,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _paymentAlerts = value);
              },
            ),
          ],
        ),
      ],
    );
  }
}
