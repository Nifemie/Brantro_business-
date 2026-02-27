import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brantro_business/features/auth/logic/auth_notifiers.dart';
import 'package:brantro_business/features/auth/data/models/login_request.dart';
import 'package:brantro_business/core/utils/app_messanger.dart';
import 'package:brantro_business/core/utils/device_utils.dart';
import 'package:brantro_business/core/utils/color_utils.dart';
import 'package:brantro_business/controllers/re_useable/app_button.dart';
import 'package:brantro_business/core/service/session_service.dart';
import '../../../../../core/utils/platform_responsive.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _hasIncorrectCred = false;
  bool _hasStoredUsername = false;

  Future<void> _login() async {
    print('========================================');
    print('[SignInScreen] Login button pressed!');
    print('[SignInScreen] Form validation starting...');
    
    if (_formKey.currentState!.validate()) {
      print('[SignInScreen] Form validation passed');
      print('[SignInScreen] Username: ${_usernameController.text.trim()}');
      print('[SignInScreen] Password length: ${_passwordController.text.length}');
      
      setState(() => _isLoading = true);

      final request = LoginRequest(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      print('[SignInScreen] LoginRequest created, calling auth notifier...');
      await ref.read(authNotifierProvider.notifier).login(request);
      print('[SignInScreen] Auth notifier login completed');
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      final authState = ref.read(authNotifierProvider);
      
      print('[SignInScreen] Auth state after login:');
      print('[SignInScreen] - isDataAvailable: ${authState.isDataAvailable}');
      print('[SignInScreen] - message: ${authState.message}');
      print('[SignInScreen] - user role: ${authState.singleData?.role}');

      if (authState.isDataAvailable) {
        print('[SignInScreen] Login successful, checking user role...');
        // Check user role BEFORE navigation
        final userRole = authState.singleData?.role?.toUpperCase();
        
        // Only allow SELLER roles and ADMIN (this is a seller/business app)
        // Seller roles: ARTIST, INFLUENCER, HOST, TV_STATION, RADIO_STATION, MEDIA_HOUSE, DESIGNER, PRODUCER, UGC_CREATOR, TALENT_MANAGER, SCREEN_BILLBOARD
        final sellerRoles = [
          'ADMIN',
          'ARTIST',
          'INFLUENCER', 
          'HOST',
          'TV_STATION',
          'RADIO_STATION',
          'MEDIA_HOUSE',
          'DESIGNER',
          'CREATIVE',
          'PRODUCER',
          'UGC_CREATOR',
          'TALENT_MANAGER',
          'SCREEN_BILLBOARD',
        ];
        
        if (sellerRoles.contains(userRole)) {
          print('[SignInScreen] User role "$userRole" is valid for seller app');
          // Role is valid - navigate to dashboard
          if (!mounted) return;
          setState(() => _isLoading = false);
          
          print('[SignInScreen] Navigating to dashboard...');
          context.pushReplacement('/dashboard');
          
          // Show welcome message after navigation
          Future.delayed(const Duration(milliseconds: 500), () async {
            if (!mounted) return;
            
            // Get user's name from session
            final userName = await SessionService.getUserFullname() ?? 
                            await SessionService.getUsername() ?? 
                            'User';
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome back, $userName!'),
                backgroundColor: AppColors.primaryColor,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: 80.h, // Position above bottom nav
                  left: 16.w,
                  right: 16.w,
                ),
              ),
            );
          });
        } else {
          print('[SignInScreen] User role "$userRole" is NOT allowed in seller app');
          // User has a buyer/advertiser role - not allowed in this app
          // Stay on signin screen and show error
          if (!mounted) return;
          setState(() => _isLoading = false);
          
          AppMessenger.show(
            context,
            message: 'This app is for sellers and service providers only. Please use the buyer app to browse and book services.',
            type: MessageType.error,
          );
          
          // Clear the session so they can't bypass
          await SessionService.clearSession();
          print('[SignInScreen] Session cleared for unauthorized role');
        }
      } else if (authState.message != null) {
        print('[SignInScreen] Login failed with message: ${authState.message}');
        // Check if the error is about inactive account
        final errorMessage = authState.message!.toLowerCase();
        if (errorMessage.contains('inactive') || 
            errorMessage.contains('not activated') ||
            errorMessage.contains('not verified')) {
          print('[SignInScreen] Account inactive/not verified, redirecting to verification');
          // Show error message
          AppMessenger.show(
            context,
            message: authState.message!,
            type: MessageType.error,
          );
          
          // Navigate to verification screen after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            context.push(
              '/verify-identity',
              extra: {
                'email': _usernameController.text.trim(),
                'phoneNumber': _usernameController.text.trim(),
              },
            );
          });
        } else {
          // Other errors - just show the message
          print('[SignInScreen] Showing error to user: ${authState.message}');
          setState(() => _hasIncorrectCred = true);
          AppMessenger.show(
            context,
            message: authState.message!,
            type: MessageType.error,
          );
        }
      } else {
        print('[SignInScreen] No data available and no error message - unexpected state');
      }
    } else {
      print('[SignInScreen] Form validation FAILED');
    }
    print('========================================');
  }

  Future<void> _initialize() async {
    // TODO: Load stored username if available
    // Example:
    // final savedUsername = await SessionService.getUsername();
    // if (savedUsername != null) {
    //   setState(() {
    //     _usernameController.text = savedUsername;
    //     _hasStoredUsername = true;
    //   });
    // }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/promotions/billboard2.jpg',
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
            ),
          ),

          // Black gradient overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: PlatformResponsive.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppBar replacement
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => context.push('/intro'),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 100.h),

                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 50.rw,
                            height: 50.rh,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: PlatformResponsive.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: PlatformResponsive.circular(8),
                              child: Image.asset(
                                'assets/icons/launcher.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          PlatformResponsive.sizedBoxW(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Brantro',
                                style: TextStyle(
                                  fontSize: 24.rsp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Business',
                                style: TextStyle(
                                  fontSize: 14.rsp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Welcome text
                      Text(
                        'Seller Portal',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Manage your services and grow your business',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Email field
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Email / Phone Number',
                        hint: 'Username',
                        keyboardType: TextInputType.emailAddress,
                        isDark: true,
                      ),
                      SizedBox(height: 5.h),

                      // Password field
                      _buildPasswordField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '*********',
                        obscureText: _obscurePassword,
                        onToggleVisibility: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        hasError: _hasIncorrectCred,
                        isDark: true,
                      ),

                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          if (_hasIncorrectCred)
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 16,
                            ),
                          if (_hasIncorrectCred) SizedBox(width: 8.w),
                          if (_hasIncorrectCred)
                            const Text(
                              'Invalid Username or password',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.push('/forgot-password'),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 40.h),

                      FullWidthButton(
                        text: 'Login to Dashboard',
                        isLoading: _isLoading,
                        onPressed: _login,
                      ),
                      SizedBox(height: 16.h),

                      // Business benefits section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business_center,
                              color: AppColors.primaryColor,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'For Sellers & Service Providers Only',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // 🔹 Conditional Login Options
                      Opacity(
                        opacity: _hasStoredUsername ? 1.0 : 0.5,
                        child: Column(
                          children: [
                            _buildLoginOption(
                              icon: Icons.fingerprint,
                              label: 'Login with Thumbprint',
                              onTap: _hasStoredUsername
                                  ? () => context.push('/biometric-login')
                                  : () {
                                      AppMessenger.show(
                                        context,
                                        message:
                                            'Please login once before enabling biometric login.',
                                        type: MessageType.warning,
                                      );
                                    },
                            ),
                            SizedBox(height: 12.h),
                            _buildLoginOption(
                              icon: Icons.lock_outline,
                              label: 'Login with Passcode',
                              onTap: _hasStoredUsername
                                  ? () => context.push('/passcode-login')
                                  : () {
                                      AppMessenger.show(
                                        context,
                                        message:
                                            'Please login once before enabling passcode login.',
                                        type: MessageType.warning,
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Don't have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New seller? ",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/signup'),
                            child: Text(
                              'Register your business',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- reusable widgets ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isDark = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? 'This field is required'
              : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    bool hasError = false,
    bool isDark = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.primaryColor,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? 'This field is required'
              : null,
        ),
      ],
    );
  }

  Widget _buildLoginOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.primaryColor, size: 22),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          side: const BorderSide(color: AppColors.primaryColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
