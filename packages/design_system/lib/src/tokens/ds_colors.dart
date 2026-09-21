import 'package:flutter/material.dart';

/// The palette. Every colour in the product traces back to one of these.
///
/// Screens read [ColorScheme] from the theme rather than these constants
/// directly - the tokens exist to *build* the scheme, in one place, so a brand
/// change is one edit here instead of a grep across three apps.
abstract final class DSColors {
  // Brand
  static const Color seed = Color(0xFF3D5AFE);

  // Neutrals
  static const Color ink = Color(0xFF14161A);
  static const Color inkMuted = Color(0xFF5C636E);
  static const Color line = Color(0xFFE3E6EB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF6F7F9);

  // Status - these carry meaning, so they are named by meaning, not by hue.
  static const Color success = Color(0xFF1B8A5A);
  static const Color warning = Color(0xFFB4690E);
  static const Color danger = Color(0xFFC0342B);
  static const Color info = Color(0xFF2D6CDF);
}
