import 'package:flutter/material.dart';

/// App-wide color palette
/// All colors used throughout the application should be defined here
class AppColors {
  // ==================== Primary Colors ====================
  /// Main brand color (Orange) - Used for primary actions, buttons, and highlights
  static const Color primaryColor = Color(0xFFF76301);
  
  /// Secondary brand color (Blue) - Used for alternative actions and accents
  static const Color secondaryColor = Color(0xFF2196F3);

  // ==================== Text Colors ====================
  /// Primary text color for main content
  static const Color textPrimary = Colors.black;
  
  /// Secondary text color for less important content
  static const Color textSecondary = Color(0xFFB0B0B0); // Colors.white70 equivalent
  
  /// Tertiary text color for hints and placeholders
  static const Color textTertiary = Color(0xFF9E9E9E); // Colors.grey.shade400
  
  /// Text color for dark backgrounds
  static const Color textOnDark = Colors.white;
  
  /// Text color for light backgrounds
  static const Color textOnLight = Colors.black;

  // ==================== Background Colors ====================
  /// Main background color for screens
  static const Color backgroundPrimary = Colors.white;
  
  /// Secondary background color (light grey)
  static const Color backgroundSecondary = Color(0xFFFAFAFA); // Colors.grey[50]
  
  /// Tertiary background color
  static const Color backgroundTertiary = Color(0xFFF5F5F5); // Colors.grey.shade100
  
  /// Dark background color
  static const Color backgroundDark = Colors.black;

  // ==================== Border Colors ====================
  /// Default border color
  static const Color borderDefault = Color(0xFFE0E0E0); // Colors.grey.shade300
  
  /// Focused border color (uses primary color)
  static const Color borderFocused = primaryColor;
  
  /// Error border color
  static const Color borderError = Color(0xFFD32F2F); // Colors.red

  // ==================== State Colors ====================
  /// Error color for error messages and validation
  static const Color error = Color(0xFFD32F2F); // Colors.red
  
  /// Success color for success messages
  static const Color success = Color(0xFF4CAF50);
  
  /// Warning color for warning messages
  static const Color warning = Color(0xFFFFA726);
  
  /// Info color for informational messages
  static const Color info = Color(0xFF2196F3);

  // ==================== UI Element Colors ====================
  /// Icon color on light backgrounds
  static const Color iconLight = Color(0xFF757575); // Colors.grey
  
  /// Icon color on dark backgrounds
  static const Color iconDark = Colors.white;
  
  /// Divider color
  static const Color divider = Color(0xFFE0E0E0); // Colors.grey.shade300
  
  /// Shadow color
  static const Color shadow = Color(0x0D000000); // Colors.black.withOpacity(0.05)
  
  /// Overlay color for gradients
  static const Color overlayDark = Color(0xCC000000); // Colors.black.withOpacity(0.8)
  static const Color overlayLight = Color(0x33000000); // Colors.black.withOpacity(0.2)

  // ==================== Grey Scale ====================
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ==================== Opacity Helpers ====================
  /// Creates a semi-transparent version of the primary color
  static Color primaryWithOpacity(double opacity) => 
      primaryColor.withOpacity(opacity);
  
  /// Creates a semi-transparent version of the secondary color
  static Color secondaryWithOpacity(double opacity) => 
      secondaryColor.withOpacity(opacity);
  
  /// Creates a semi-transparent black overlay
  static Color blackWithOpacity(double opacity) => 
      Colors.black.withOpacity(opacity);
  
  /// Creates a semi-transparent white overlay
  static Color whiteWithOpacity(double opacity) => 
      Colors.white.withOpacity(opacity);
}
