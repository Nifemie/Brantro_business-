import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class DeviceUtils {
  static Future<String> getIpAddress() async {
    try {
      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP();
      return wifiIP ?? '0.0.0.0';
    } catch (_) {
      return '0.0.0.0';
    }
  }

  static Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return android.model;
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.name;
    } else {
      return 'Unknown Device';
    }
  }

  static Future<String> getDeviceOS() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return 'Android ${android.version.release}';
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return 'iOS ${ios.systemVersion}';
    } else {
      return Platform.operatingSystem;
    }
  }

  /// Get unique device ID for device-specific biometric authentication
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      // Use androidId as unique device identifier
      return android.id;
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      // Use identifierForVendor as unique device identifier
      return ios.identifierForVendor ?? 'unknown_ios_device';
    } else {
      return 'unknown_device';
    }
  }
}
