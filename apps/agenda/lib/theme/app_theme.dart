import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Material 3 themes built from design-system tokens.
///
/// No screen writes a raw `Color(0x...)`; it reads `Theme.of(context)` or a
/// token. That is what makes a rebrand one file instead of a grep.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: DSColors.seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? DSColors.surfaceAlt
          : colorScheme.surface,
      textTheme:
          const TextTheme(
            displayLarge: DSTypography.displayLarge,
            titleLarge: DSTypography.titleLarge,
            titleMedium: DSTypography.titleMedium,
            bodyLarge: DSTypography.bodyLarge,
            bodyMedium: DSTypography.bodyMedium,
            labelMedium: DSTypography.label,
          ).apply(
            bodyColor: colorScheme.onSurface,
            displayColor: colorScheme.onSurface,
          ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: DSRadius.allSm),
        contentPadding: EdgeInsets.symmetric(
          horizontal: DSSpacing.md,
          vertical: DSSpacing.md,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: const RoundedRectangleBorder(borderRadius: DSRadius.allMd),
        ),
      ),
    );
  }
}
