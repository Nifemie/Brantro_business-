import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_color.dart';

/// App-wide text styles
/// All text styles used throughout the application should be defined here
/// Uses flutter_screenutil for responsive sizing
class AppTexts {
  // ==================== Display Text Styles ====================
  /// Large display text - Used for main headings and hero text
  /// Example: "Welcome Back", "Create account"
  static TextStyle displayLarge({Color? color}) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Medium display text - Used for section headings
  static TextStyle displayMedium({Color? color}) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Small display text - Used for sub-headings
  static TextStyle displaySmall({Color? color}) => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  // ==================== Heading Text Styles ====================
  /// Heading 1 - Large headings
  static TextStyle h1({Color? color}) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 2 - Medium headings
  static TextStyle h2({Color? color}) => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 3 - Small headings
  static TextStyle h3({Color? color}) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 4 - Extra small headings
  static TextStyle h4({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  // ==================== Body Text Styles ====================
  /// Body large - Main content text
  static TextStyle bodyLarge({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      );

  /// Body medium - Standard body text
  static TextStyle bodyMedium({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      );

  /// Body small - Small body text
  static TextStyle bodySmall({Color? color}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      );

  // ==================== Label Text Styles ====================
  /// Label large - Form labels and important labels
  static TextStyle labelLarge({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Label medium - Standard labels
  static TextStyle labelMedium({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  /// Label small - Small labels and captions
  static TextStyle labelSmall({Color? color}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  // ==================== Button Text Styles ====================
  /// Button large - Large button text
  static TextStyle buttonLarge({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
      );

  /// Button medium - Standard button text
  static TextStyle buttonMedium({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  /// Button small - Small button text
  static TextStyle buttonSmall({Color? color}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  // ==================== Specialized Text Styles ====================
  /// Subtitle text - Used for descriptions and secondary information
  /// Example: "Enter details to Login into your account"
  static TextStyle subtitle({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textSecondary,
      );

  /// Subtitle bold - Bold version of subtitle
  static TextStyle subtitleBold({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textSecondary,
      );

  /// Caption - Small descriptive text
  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: 14.sp,
        color: color ?? AppColors.grey600,
      );

  /// Hint text - Placeholder text in input fields
  static TextStyle hint({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.grey400,
      );

  /// Error text - Error messages
  static TextStyle error({Color? color}) => TextStyle(
        fontSize: 12.sp,
        color: color ?? AppColors.error,
      );

  /// Link text - Clickable links
  static TextStyle link({Color? color}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.primaryColor,
      );

  /// Link large - Larger clickable links
  static TextStyle linkLarge({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.primaryColor,
      );

  // ==================== Input Field Text Styles ====================
  /// Input text - Text inside input fields (light background)
  static TextStyle inputText({Color? color}) => TextStyle(
        fontSize: 14.sp,
        color: color ?? AppColors.textPrimary,
      );

  /// Input text dark - Text inside input fields (dark background)
  static TextStyle inputTextDark({Color? color}) => TextStyle(
        fontSize: 14.sp,
        color: color ?? Colors.white,
      );

  /// Input label - Labels for input fields
  static TextStyle inputLabel({Color? color, bool isDark = false}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: color ?? (isDark ? Colors.white : AppColors.textPrimary),
      );

  // ==================== Special Purpose Text Styles ====================
  /// Logo text - Brand name text
  static TextStyle logo({Color? color}) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Logo large - Larger brand name text
  static TextStyle logoLarge({Color? color}) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Dialog title - Title text in dialogs
  static TextStyle dialogTitle({Color? color}) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  /// Dialog option title - Option titles in dialogs
  static TextStyle dialogOptionTitle({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  /// Dialog option subtitle - Option subtitles in dialogs
  static TextStyle dialogOptionSubtitle({Color? color}) => TextStyle(
        fontSize: 14.sp,
        color: color ?? AppColors.grey600,
      );

  // ==================== Text Style Modifiers ====================
  /// Apply bold weight to any text style
  static TextStyle bold(TextStyle style) => style.copyWith(
        fontWeight: FontWeight.bold,
      );

  /// Apply semi-bold weight to any text style
  static TextStyle semiBold(TextStyle style) => style.copyWith(
        fontWeight: FontWeight.w600,
      );

  /// Apply medium weight to any text style
  static TextStyle medium(TextStyle style) => style.copyWith(
        fontWeight: FontWeight.w500,
      );

  /// Apply italic style to any text style
  static TextStyle italic(TextStyle style) => style.copyWith(
        fontStyle: FontStyle.italic,
      );

  /// Apply underline to any text style
  static TextStyle underline(TextStyle style) => style.copyWith(
        decoration: TextDecoration.underline,
      );

  /// Apply custom color to any text style
  static TextStyle withColor(TextStyle style, Color color) => style.copyWith(
        color: color,
      );

  /// Apply custom font size to any text style
  static TextStyle withSize(TextStyle style, double size) => style.copyWith(
        fontSize: size.sp,
      );
}
