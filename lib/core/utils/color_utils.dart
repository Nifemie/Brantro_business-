
import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFFF76301);
  // Add other colors here
}

// You can also define a class for the theme colors
class AppThemeColors {
  final Color primaryColor;

  AppThemeColors({required this.primaryColor});
}

final appTheme = AppThemeColors(primaryColor: AppColors.primaryColor);
