import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    // Color scheme (customize per your palette)
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3B82F6),
      // primary-500
      onPrimary: Colors.white,
      secondary: Color(0xFF60A5FA),
      // maybe a lighter primary or accent
      onSecondary: Colors.white,
      // neutral-800
      surface: Color(0xFFF5F5F5),
      onSurface: Color(0xFF262626),
      error: Color(0xFFEF4444),
      // error-500
      onError: Colors.white,
    ),

    // Scaffold / background
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    // neutral-100

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      // primary
      foregroundColor: Colors.black87,
      // icon/text color
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.black87,
      ),

      // For status bar icon brightness, you'd use systemOverlayStyle if needed
    ),

    // BottomNavigationBar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF3B82F6),
      unselectedItemColor: const Color(0xFF737373),
      // neutral-500
      selectedIconTheme: const IconThemeData(
        size: 24,
        color: Color(0xFF3B82F6),
      ),
      unselectedIconTheme: const IconThemeData(
        size: 22,
        color: Color(0xFFA3A3A3),
      ),
      // neutral-400
      showUnselectedLabels: true,
      elevation: 8,
    ),

    // Icon theme for general icons
    iconTheme: const IconThemeData(
      color: Color(0xFF262626), // neutral-800
      size: 24,
    ),

    // Text Theme — using your Noto Sans font weights
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w800, // ExtraBold
        fontSize: 57,
      ),
      displayMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w700, // Bold
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600, // SemiBold
        fontSize: 36,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w800,
        fontSize: 36,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500, // Medium
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      titleSmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400, // Regular
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w300, // Light (if you have Light)
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      labelSmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
    ),

    // Input (TextField) Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD4D4D4)), // neutral-300
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD4D4D4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: const Color(0xFF3B82F6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        color: Color(0xFF525252), // neutral-600
      ),
      hintStyle: const TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        color: Color(0xFF838383),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        color: Color(0xFFEF4444),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'NotoSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        backgroundColor: const Color(0xFF3B82F6),
        // blue-500
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFE5E5E5),
        // neutral-200
        disabledForegroundColor: const Color(0xFFA3A3A3),
        // neutral-400
        elevation: 2,
      ),
    ),

    fontFamily: 'NotoSans',
  );

  // Dark Theme
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2563EB),
      // primary-600 or dark primary
      onPrimary: Colors.white,
      secondary: Color(0xFF60A5FA),
      onSecondary: Colors.black,
      // neutral-900
      surface: Color(0xFF1E1E1E),
      // neutral-300 (dark)
      onSurface: Color(0xFFF5F5F5),
      error: Color(0xFFDC2626),
      // error-600
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFF1E1E1E),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.white,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF2C2C2C),
      selectedItemColor: const Color(0xFF60A5FA),
      unselectedItemColor: const Color(0xFF707070),
      // neutral-600
      selectedIconTheme: const IconThemeData(
        size: 24,
        color: Color(0xFF60A5FA),
      ),
      unselectedIconTheme: const IconThemeData(
        size: 22,
        color: Color(0xFF707070),
      ),
      showUnselectedLabels: true,
      elevation: 8,
    ),

    iconTheme: const IconThemeData(color: Color(0xFFF5F5F5), size: 24),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w800,
        fontSize: 57,
        color: Color(0xFFF5F5F5),
      ),
      displayMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w700,
        fontSize: 45,
        color: Color(0xFFF5F5F5),
      ),
      displaySmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600,
        fontSize: 36,
        color: Color(0xFFF5F5F5),
      ),
      headlineMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600,
        fontSize: 28,
        color: Color(0xFFF5F5F5),
      ),
      headlineSmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Color(0xFFF5F5F5),
      ),
      titleLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Color(0xFFF5F5F5),
      ),
      titleMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Color(0xFFF5F5F5),
      ),
      titleSmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color(0xFFF5F5F5),
      ),
      bodyLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Color(0xFFF5F5F5),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFFF5F5F5),
      ),
      bodySmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w300,
        fontSize: 12,
        color: Color(0xFFB0B0B0), // slightly lighter neutral
      ),
      labelLarge: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color(0xFFF5F5F5),
      ),
      labelSmall: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        fontSize: 11,
        color: Color(0xFFB0B0B0),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        color: Color(0xFF707070),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        color: Color(0xFFA3A3A3),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w400,
        color: Color(0xFFDC2626),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'NotoSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        backgroundColor: const Color(0xFF2563EB),
        // blue-500
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF404040),
        // neutral-700
        disabledForegroundColor: const Color(0xFF737373),
        // neutral-500
        elevation: 2,
      ),
    ),

    fontFamily: 'NotoSans',
  );
}
