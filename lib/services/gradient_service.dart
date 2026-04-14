import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

/// Service for generating dynamic gradients from product images
class GradientService {
  /// Cache for generated gradients to avoid redundant processing
  static final Map<String, LinearGradient> _gradientCache = {};

  /// Extract dominant colors from image and create a gradient
  static Future<LinearGradient> generateGradientFromImage(
    String imageUrl, {
    LinearGradient? fallbackGradient,
  }) async {
    // Check cache first
    if (_gradientCache.containsKey(imageUrl)) {
      return _gradientCache[imageUrl]!;
    }

    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
      );

      // Extract colors
      final Color dominantColor =
          paletteGenerator.dominantColor?.color ?? const Color(0xFFD4AF37);
      final Color accentColor =
          paletteGenerator.vibrantColor?.color ?? dominantColor.withOpacity(0.7);

      // Create gradient
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          dominantColor.withOpacity(0.15),
          accentColor.withOpacity(0.08),
        ],
      );

      // Cache the gradient
      _gradientCache[imageUrl] = gradient;
      return gradient;
    } catch (e) {
      // Return fallback gradient on error
      return fallbackGradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE8E8E8).withOpacity(0.15),
              const Color(0xFFF5F5F5).withOpacity(0.08),
            ],
          );
    }
  }

  /// Extract dominant color from image
  static Future<Color> extractDominantColor(
    String imageUrl, {
    Color? fallbackColor,
  }) async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
      );

      return paletteGenerator.dominantColor?.color ??
          fallbackColor ??
          const Color(0xFFD4AF37);
    } catch (e) {
      return fallbackColor ?? const Color(0xFFD4AF37);
    }
  }

  /// Get a complementary color for accent elements
  static Future<Color> extractAccentColor(
    String imageUrl, {
    Color? fallbackColor,
  }) async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
      );

      return paletteGenerator.vibrantColor?.color ??
          paletteGenerator.mutedColor?.color ??
          fallbackColor ??
          const Color(0xFFD4AF37);
    } catch (e) {
      return fallbackColor ?? const Color(0xFFD4AF37);
    }
  }

  /// Create a sophisticated gradient with multiple colors
  static Future<LinearGradient> generateAdvancedGradient(
    String imageUrl, {
    LinearGradient? fallbackGradient,
  }) async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
      );

      final Color primary =
          paletteGenerator.dominantColor?.color ?? const Color(0xFFD4AF37);
      final Color secondary =
          paletteGenerator.vibrantColor?.color ?? primary.withOpacity(0.7);
      final Color tertiary =
          paletteGenerator.mutedColor?.color ?? primary.withOpacity(0.5);

      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withOpacity(0.2),
          secondary.withOpacity(0.1),
          tertiary.withOpacity(0.05),
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } catch (e) {
      return fallbackGradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE8E8E8).withOpacity(0.15),
              const Color(0xFFF5F5F5).withOpacity(0.08),
            ],
          );
    }
  }

  /// Clear the gradient cache
  static void clearCache() {
    _gradientCache.clear();
  }

  /// Get cache size
  static int getCacheSize() {
    return _gradientCache.length;
  }
}
