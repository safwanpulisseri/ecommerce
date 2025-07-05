import 'package:flutter/material.dart';

final class AppColor {
  AppColor._();

  // Primary Colors
  static const Color background = Colors.white;
  static const Color primary = Colors.black;
  static const Color secondary = Colors.black;

  // Surface Colors
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color surfaceContainer = Color(0xFFE8E8E8);

  // Text Colors
  static const Color onBackground = Colors.black;
  static const Color onSurface = Colors.black;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Accent Colors
  static const Color accent = Color(0xFFB5E4CA);
  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFF56500);
  static const Color info = Color(0xFF3182CE);

  // Interactive Colors
  static const Color favorite = Color(0xFFE53E3E);
  static const Color selectedTab = Colors.black;
  static const Color unselectedTab = Color(0xFF9E9E9E);

  // Border & Divider Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Shadow Colors
  static Color shadow = Colors.black.withOpacity(0.1);
  static Color shadowLight = Colors.black.withOpacity(0.05);

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Transparent Colors
  static Color transparent = Colors.transparent;
}
