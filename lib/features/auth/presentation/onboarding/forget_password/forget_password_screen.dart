import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;
import '../../../../../core/utils/app_messanger.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../controllers/re_useable/app_button.dart';
import '../../../logic/auth_notifiers.dart';
import '../../../data/models/forgot_password_request.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  bool _isLoading = false;
  bool _showDebugLogs = false;
  final List<String> _debugLogs = [];

  Future<void> _forgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final identity = _identityController.text.trim();
        _addDebugLog('🔑 Starting forgot password with: $identity');
        developer.log('🔑 [FORGOT PASSWORD] Starting with identity: $identity');

        final request = ForgotPasswordRequest(identity: identity);
        _addDebugLog('📧 Request created successfully');
        developer.log('📧 [FORGOT PASSWORD] Request created successfully');

        // Call the notifier
        _addDebugLog('📡 Calling API...');
        await ref.read(authNotifierProvider.notifier).forgotPassword(request);
        _addDebugLog('✅ API call completed');
        developer.log('✅ [FORGOT PASSWORD] Notifier call completed');

        if (!mounted) return;

        final authState = ref.read(authNotifierProvider);
        _addDebugLog(
          '📊 Auth state: isDataAvailable=${authState.isDataAvailable}',
        );
        developer.log(
          '📊 [FORGOT PASSWORD] Auth state - isDataAvailable: ${authState.isDataAvailable}, message: ${authState.message}',
        );

        if (authState.isDataAvailable) {
          _addDebugLog('✅ Success! Message: ${authState.message}');
          developer.log('✅ [FORGOT PASSWORD] Success! Showing success message');
          AppMessenger.show(
            context,
            type: MessageType.success,
            message: authState.message ?? 'OTP sent to your email',
          );

          // Navigate to verification screen
          _addDebugLog('🔄 Navigating to verification screen...');
          developer.log(
            '🔄 [FORGOT PASSWORD] Navigating to verification screen',
          );
          context.push(
            '/forgot-password-verification',
            extra: {'identity': identity},
          );
        } else if (authState.message != null) {
          _addDebugLog('❌ Error: ${authState.message}');
          developer.log('❌ [FORGOT PASSWORD] Error: ${authState.message}');
          AppMessenger.show(
            context,
            type: MessageType.error,
            message: authState.message!,
          );
        }
      } catch (e) {
        _addDebugLog('❌ Exception: $e');
        developer.log('❌ [FORGOT PASSWORD] Exception caught: $e');
        if (!mounted) return;
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: 'An unexpected error occurred: ${e.toString()}',
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _addDebugLog(String message) {
    setState(() {
      _debugLogs.add(
        '[${DateTime.now().toIso8601String().split('T')[1].substring(0, 8)}] $message',
      );
      if (_debugLogs.length > 20) {
        _debugLogs.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your email or phone number to reset your password',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email or Phone Number',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _identityController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email address or phone number',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email or phone number is required';
                      }

                      // Check if valid email
                      final isValidEmail = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(value);

                      // Check if valid phone (7-15 digits, allowing common formatting)
                      final cleaned = value.replaceAll(
                        RegExp(r'[\s\-\(\)\.+]'),
                        '',
                      );
                      final isValidPhone = RegExp(
                        r'^\d{7,15}$',
                      ).hasMatch(cleaned);

                      if (!isValidEmail && !isValidPhone) {
                        return 'Please enter a valid email address or phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),

              FullWidthButton(
                text: 'Continue',
                isLoading: _isLoading,
                onPressed: _forgotPassword,
              ),

              const SizedBox(height: 16),

              // Back to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Remember your password? ',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/signin');
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }
}
