import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';

/// The type scale.
///
/// Line height is set as a multiple of font size (1.4-1.6) because that is what
/// keeps body text readable; the numbers are not arbitrary.
abstract final class DSTypography {
  static const String fontFamily = 'Roboto';

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: DSColors.ink,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: DSColors.ink,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 17,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: DSColors.ink,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: DSColors.ink,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: DSColors.inkMuted,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: DSColors.inkMuted,
  );
}
