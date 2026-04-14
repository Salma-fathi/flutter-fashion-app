import 'package:flutter/material.dart';

/// KINETIC Theme - Material Design 3 Color System
/// Premium luxury fashion e-commerce application
class KineticTheme {
  // Primary Colors - Electric Blue
  static const Color primary = Color(0xFF003FDD);
  static const Color primaryContainer = Color(0xFF2B59FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFECEDFF);

  // Secondary Colors - Warm Beige
  static const Color secondary = Color(0xFF5E604D);
  static const Color secondaryContainer = Color(0xFFE1E1C9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF636451);

  // Tertiary Colors - Charcoal
  static const Color tertiary = Color(0xFF545353);
  static const Color tertiaryContainer = Color(0xFF6C6B6B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFF0EDEC);

  // Surface Colors
  static const Color background = Color(0xFFFBF9F4);
  static const Color surface = Color(0xFFFBF9F4);
  static const Color surfaceVariant = Color(0xFFE4E2DD);
  static const Color onSurface = Color(0xFF1B1C19);
  static const Color onSurfaceVariant = Color(0xFF434656);

  // Surface Container Colors
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3EE);
  static const Color surfaceContainer = Color(0xFFF0EEE9);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E3);
  static const Color surfaceContainerHighest = Color(0xFFE4E2DD);

  // Outline Colors
  static const Color outline = Color(0xFF747688);
  static const Color outlineVariant = Color(0xFFC4C5D9);

  // Error Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Additional Colors
  static const Color inverseSurface = Color(0xFF30312E);
  static const Color inverseOnSurface = Color(0xFFF2F1EC);
  static const Color inversePrimary = Color(0xFFB9C3FF);

  // Fixed Colors
  static const Color primaryFixed = Color(0xFFDDE1FF);
  static const Color primaryFixedDim = Color(0xFFB9C3FF);
  static const Color onPrimaryFixed = Color(0xFF001356);
  static const Color onPrimaryFixedVariant = Color(0xFF0035BE);

  static const Color secondaryFixed = Color(0xFFE4E4CC);
  static const Color secondaryFixedDim = Color(0xFFC8C8B0);
  static const Color onSecondaryFixed = Color(0xFF1B1D0E);
  static const Color onSecondaryFixedVariant = Color(0xFF474836);

  static const Color tertiaryFixed = Color(0xFFE5E2E1);
  static const Color tertiaryFixedDim = Color(0xFFC8C6C5);
  static const Color onTertiaryFixed = Color(0xFF1C1B1B);
  static const Color onTertiaryFixedVariant = Color(0xFF474746);

  // Tint Color
  static const Color surfaceTint = Color(0xFF1049F1);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xFFB9C3FF);
  static const Color darkOnPrimary = Color(0xFF001356);
  static const Color darkBackground = Color(0xFF30312E);
  static const Color darkSurface = Color(0xFF30312E);
  static const Color darkOnSurface = Color(0xFFF2F1EC);

  // Glassmorphism Colors
  static const Color glassLight = Color(0xFFFFFFFF);
  static const Color glassDark = Color(0xFF30312E);

  // Neubrutalism Shadow
  static const Color neubrutalismshadow = Color(0xFF003FDD);

  /// Get Material Color Scheme for Light Theme
  static ColorScheme getLightColorScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onSurface,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }

  /// Get Material Color Scheme for Dark Theme
  static ColorScheme getDarkColorScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: darkOnPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFFDDE1FF),
      secondary: Color(0xFFC8C8B0),
      onSecondary: Color(0xFF1B1D0E),
      secondaryContainer: Color(0xFF3F4135),
      onSecondaryContainer: Color(0xFFE1E1C9),
      tertiary: Color(0xFFC8C6C5),
      onTertiary: Color(0xFF1C1B1B),
      tertiaryContainer: Color(0xFF3F3E3D),
      onTertiaryContainer: Color(0xFFE5E2E1),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      background: darkBackground,
      onBackground: darkOnSurface,
      surface: darkSurface,
      onSurface: darkOnSurface,
      surfaceVariant: Color(0xFF49454E),
      onSurfaceVariant: Color(0xFFCAC7D0),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454E),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFF2F1EC),
      onInverseSurface: Color(0xFF30312E),
      inversePrimary: primary,
    );
  }

  /// Get ThemeData for Light Theme
  static ThemeData getLightTheme() {
    final colorScheme = getLightColorScheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: onSurface,
          letterSpacing: 0.5,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: onSurface,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: 0,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: 0,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurface,
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: onSurfaceVariant,
          letterSpacing: 0.5,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant.withOpacity(0.5),
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainer,
        disabledColor: surfaceContainer,
        selectedColor: primary,
        secondarySelectedColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onPrimary,
        ),
        brightness: Brightness.light,
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 1,
        space: 16,
      ),
    );
  }

  /// Get ThemeData for Dark Theme
  static ThemeData getDarkTheme() {
    final colorScheme = getDarkColorScheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkOnSurface,
          letterSpacing: 0.5,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: darkOnSurface,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
          letterSpacing: 0,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
          letterSpacing: 0,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkOnSurface,
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkOnSurface,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFFCAC7D0),
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
