import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/models/signup_request.dart';
import '../../../core/constants/enum.dart';
import 'auth_notifiers.dart';

/// Handles business logic for role details form submission
class RoleDetailsHandler {
  final WidgetRef ref;
  final BuildContext context;

  RoleDetailsHandler(this.ref, this.context);

  /// Collect form data from controllers
  Map<String, dynamic> collectFormData(
    Map<String, TextEditingController> controllers,
  ) {
    final formData = <String, dynamic>{};
    controllers.forEach((key, controller) {
      formData[key] = controller.text;
    });
    return formData;
  }

  /// Check if role and account type require direct signup (Individual Advertiser)
  bool shouldSignupDirectly(String role, String accountType) {
    return role == 'Advertiser' &&
        (accountType.toLowerCase().contains('personal') ||
            accountType.toLowerCase().contains('individual'));
  }

  /// Handle form submission - either signup directly or navigate to account details
  Future<void> handleSubmit({
    required String role,
    required String accountType,
    required Map<String, dynamic> formData,
    required Function(bool) setLoading,
  }) async {
    if (shouldSignupDirectly(role, accountType)) {
      await signupIndividualAdvertiser(formData, setLoading);
    } else {
      await navigateToAccountDetails(
        role: role,
        accountType: accountType,
        roleData: formData,
        setLoading: setLoading,
      );
    }
  }

  /// Signup individual advertiser directly (no account details screen needed)
  Future<void> signupIndividualAdvertiser(
    Map<String, dynamic> formData,
    Function(bool) setLoading,
  ) async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // For individual advertisers, advertiserInfo is null - they only provide personal info
    final signUpRequest = SignUpRequest(
      role: UserRole.ADVERTISER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: AccountType.INDIVIDUAL.value,
      advertiserInfo: null,
      name: formData['fullName'] ?? '',
      emailAddress: formData['email'] ?? '',
      phoneNumber: formData['phoneNumber'] ?? '',
      password: formData['password'] ?? '',
      country: 'Nigeria',
      state: formData['state'],
      city: formData['city'],
      address: formData['streetAddress'],
    );

    await authNotifier.signupUser(signUpRequest);
    await handleSignupResponse(formData, setLoading);
  }

  /// Handle signup response - show success/error and navigate
  Future<void> handleSignupResponse(
    Map<String, dynamic> formData,
    Function(bool) setLoading,
  ) async {
    if (!context.mounted) return;

    final authState = ref.read(authNotifierProvider);

    if (authState.isDataAvailable) {
      setLoading(false);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message ?? 'Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to verification screen with email and phone number
        context.push(
          '/verify-identity',
          extra: {
            'email': formData['email'],
            'phoneNumber': formData['phoneNumber'],
          },
        );
      }
    } else if (authState.message != null) {
      setLoading(false);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to account details screen for other roles
  Future<void> navigateToAccountDetails({
    required String role,
    required String accountType,
    required Map<String, dynamic> roleData,
    required Function(bool) setLoading,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (context.mounted) {
      setLoading(false);
      context.push(
        '/account-details',
        extra: {
          'role': role,
          'accountType': accountType,
          'roleData': roleData,
        },
      );
    }
  }
}
