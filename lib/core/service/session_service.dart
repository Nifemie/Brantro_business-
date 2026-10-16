import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage_service.dart';
import '../../features/dashboard/logic/dashboard_navigation_provider.dart';
import '../../features/account/logic/profile_provider.dart';
import '../../features/account/logic/persona_provider.dart';
import '../../features/wallet/logic/wallet_notifier.dart';
import '../../features/account/logic/analytics_provider.dart';
import '../../features/notification/logic/notification_provider.dart';
import '../../features/wallet/logic/withdrawal_accounts_notifier.dart';

class SessionService {
  late BuildContext context;
  SessionService(BuildContext incomingBuildContext) {
    context = incomingBuildContext;
  }

  static const String _userDetailsKey = 'user_details';
  static const String _userAccessToken = 'user_access_token';
  static const String _usernameKey = 'username';
  static const String _userFullnameKey = 'user_fullname';
  static const String _userActualUsernameKey = 'user_actual_username';
  static const String _userPhoneNumberKey = 'user_phone_number';

  // Save login session
  static Future<void> saveSession(dynamic response) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save user details
    if (response.user != null) {
      await prefs.setString(_userDetailsKey, jsonEncode(response.user.toJson()));
      await prefs.setString(_usernameKey, response.user.emailAddress ?? '');
      await prefs.setString(_userFullnameKey, response.user.name ?? '');
      await prefs.setString(_userPhoneNumberKey, response.user.phoneNumber ?? '');
    }
    
    // Save access token if available
    if (response.accessToken != null) {
      await prefs.setString(_userAccessToken, response.accessToken!);
    }
  }

  // Update/save cached user details
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDetailsKey, jsonEncode(user));
    if (user['name'] != null && user['name'].toString().isNotEmpty) {
      await prefs.setString(_userFullnameKey, user['name'].toString());
    }
    if (user['phoneNumber'] != null && user['phoneNumber'].toString().isNotEmpty) {
      await prefs.setString(_userPhoneNumberKey, user['phoneNumber'].toString());
    }
    if (user['emailAddress'] != null && user['emailAddress'].toString().isNotEmpty) {
      await prefs.setString(_usernameKey, user['emailAddress'].toString());
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_userAccessToken);
    if (accessToken == null) return null;
    return accessToken;
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    if (username == null) return null;
    return username;
  }

  static Future<String?> getUserFullname() async {
    final prefs = await SharedPreferences.getInstance();
    final userFullname = prefs.getString(_userFullnameKey);
    if (userFullname == null) return null;
    return userFullname;
  }

  static Future<String?> getActualUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_userActualUsernameKey);
    if (username == null) return null;
    return username;
  }

  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString(_userPhoneNumberKey);
    if (phoneNumber == null) return null;
    return phoneNumber;
  }

  static Future<dynamic> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userDetailsKey);
    if (userJson == null) return null;
    // TODO: Uncomment when UserModel is created
    // return UserModel.fromJson(jsonDecode(userJson));
    return jsonDecode(userJson);
  }

  /// Get all roles assigned to current user as a normalized List of uppercase strings
  static Future<List<String>> getRoles() async {
    final user = await getUser();
    if (user == null) return [];

    final List<String> result = [];

    // Check 'roles' array/string
    if (user['roles'] != null) {
      if (user['roles'] is List) {
        for (var r in (user['roles'] as List)) {
          if (r != null && r.toString().isNotEmpty) {
            result.add(r.toString().trim().toUpperCase());
          }
        }
      } else if (user['roles'] is String) {
        final rolesStr = user['roles'] as String;
        final split = rolesStr.split(',');
        for (var r in split) {
          if (r.trim().isNotEmpty) {
            result.add(r.trim().toUpperCase());
          }
        }
      }
    }

    // Check fallback single 'role' field
    if (user['role'] != null && user['role'].toString().isNotEmpty) {
      final singleRole = user['role'].toString().trim().toUpperCase();
      if (!result.contains(singleRole)) {
        result.add(singleRole);
      }
    }

    return result;
  }

  /// Check if user has a specific role (case-insensitive)
  static Future<bool> hasRole(String role) async {
    final roles = await getRoles();
    final target = role.trim().toUpperCase();
    return roles.contains(target);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final user = await getUser();
    return token != null && token.isNotEmpty && user != null;
  }

  // Clear all session data from local storage
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDetailsKey);
    await prefs.remove(_userAccessToken);
    await prefs.remove(_usernameKey);
    await prefs.remove(_userFullnameKey);
    await prefs.remove(_userPhoneNumberKey);
    await prefs.remove(_userActualUsernameKey);
    await prefs.clear();
  }

  /// Complete logout clearing storage, invalidating providers, and resetting router to /signin
  static Future<void> performFullLogout(
    WidgetRef ref,
    BuildContext context,
  ) async {
    // 1. Invalidate all user-specific state providers
    ref.invalidate(dashboardNavigationProvider);
    ref.invalidate(profileHeaderProvider);
    ref.invalidate(walletProvider);
    ref.invalidate(userAnalyticsProvider);
    ref.invalidate(notificationProvider);
    ref.invalidate(withdrawalAccountsProvider);
    ref.invalidate(activePersonaProvider);

    // 2. Clear all local storage preferences
    await clearSession();

    // 3. Navigate directly to /signin root route
    if (context.mounted) {
      context.go('/signin');
    }
  }

  /// Complete logout clearing storage, resetting router to /signin
  static Future<void> performLogout({
    BuildContext? context,
  }) async {
    await clearSession();
    if (context != null && context.mounted) {
      context.go('/signin');
    }
  }

  Future<void> logout() async {
    await SessionService.clearSession();
    if (context.mounted) {
      context.go('/signin');
    }
  }

  Future<void> checkSession() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (loggedIn) {
      if (context.mounted) {
        context.go('/dashboard');
      }
    } else {
      await logout();
    }
  }
}
