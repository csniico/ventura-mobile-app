import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    // Color scheme (customize per your palette)
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 13, 97, 233),
      onPrimary: Colors.white,
      secondary: const Color(0xFF60A5FA),
      onSecondary: Colors.white,

      // Core surfaces
      surface: const Color.fromARGB(
        255,
        235,
        246,
        255,
      ), // Slightly brighter than before (neutral-50)
      onSurface: const Color(
        0xFF1F1F1F,
      ), // For subtle dividers / lower emphasis
      onSurfaceVariant: const Color(0xFF424242),

      // Container family — this is what you'll use for cards
      surfaceContainerLowest: const Color(
        0xFFFFFFFF,
      ), // Pure white — perfect for standout cards
      surfaceContainerLow: const Color(0xFFD6D6D6),
      surfaceContainer: const Color.fromARGB(255, 214, 214, 214),
      surfaceContainerHigh: const Color.fromARGB(255, 214, 214, 214),
      surfaceContainerHighest: const Color.fromARGB(255, 214, 214, 214),

      error: const Color(0xFFEF4444),
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Matches surface

    cardTheme: const CardThemeData(
      color: null, // Will use surfaceContainerLowest by default in M3
      elevation: 0, // No shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    // neutral-100

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD4D4D8),
      // primary
      foregroundColor: Colors.black87,
      // icon/text color
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
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
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800, // ExtraBold
        fontSize: 57,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700, // Bold
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600, // SemiBold
        fontSize: 36,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
        fontSize: 36,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500, // Medium
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400, // Regular
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300, // Light (if you have Light)
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
    ),

    // Input (TextField) Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
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
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        color: Color(0xFF525252), // neutral-600
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFF838383),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFFEF4444),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
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

    fontFamily: 'Inter',
  );

  // Dark Theme
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,

    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF3B82F6),
      onPrimary: Colors.white,
      secondary: const Color(0xFF60A5FA),
      onSecondary: Colors.white,

      // Your requested dark surface as base
      surface: const Color.fromARGB(255, 46, 52, 56), // #2E3438
      onSurface: Colors.white, // light gray-blue — good readability
      onSurfaceVariant: Colors.white, // muted blue-gray text
      // Container family — layered around your #2E3438 base
      surfaceContainerLowest: const Color(
        0xFF1A1F22,
      ), // deepest layer / background-like
      surfaceContainerLow: const Color(0xFF24292D),
      surfaceContainer: const Color.fromARGB(
        255,
        46,
        52,
        56,
      ), // matches surface
      surfaceContainerHigh: const Color(
        0xFF5A6369,
      ), // ← recommended for cards — clearly lighter
      surfaceContainerHighest: const Color(
        0xFF6B747B,
      ), // strongest emphasis / selected/hover

      error: const Color(0xFFF87171), // softer red for dark mode
      onError: const Color(0xFF1F1F1F),
    ),

    scaffoldBackgroundColor: const Color(0xFF171717),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF171717),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
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
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
        fontSize: 57,
        color: Color(0xFFF5F5F5),
      ),
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 45,
        color: Color(0xFFF5F5F5),
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 36,
        color: Color(0xFFF5F5F5),
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 28,
        color: Color(0xFFF5F5F5),
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Color(0xFFF5F5F5),
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Color(0xFFF5F5F5),
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Color(0xFFF5F5F5),
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color(0xFFF5F5F5),
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Color(0xFFF5F5F5),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFFF5F5F5),
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300,
        fontSize: 12,
        color: Color(0xFFB0B0B0), // slightly lighter neutral
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color(0xFFF5F5F5),
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 11,
        color: Color(0xFFB0B0B0),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1F22),
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
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        color: Color(0xFF707070),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFFA3A3A3),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFFDC2626),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
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

    fontFamily: 'Inter',
  );
}
