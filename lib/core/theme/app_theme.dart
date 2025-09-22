// File: lib/core/theme/app_theme.dart | Description: 전역 테마와 색상 팔레트 정의.
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    // 🎨 라이트 테마 정의
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A6CF7)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8FAFF),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFF4A6CF7),
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedLabelTextStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        indicatorColor: Color(0xFF4A6CF7),
        backgroundColor: Colors.white,
        labelTextStyle: MaterialStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
