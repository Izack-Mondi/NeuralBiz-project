import 'package:flutter/material.dart';

import 'nexify_colors.dart';
import 'nexify_motion.dart';
import 'nexify_radius.dart';
import 'nexify_shadows.dart';
import 'nexify_spacing.dart';
import 'nexify_typography.dart';

class NexifyTheme {
  NexifyTheme._();

  static ThemeData get dark {
    final textTheme = ThemeData.dark().textTheme.copyWith(
      displayLarge: NexifyTypography.headlineLarge.copyWith(color: NexifyColors.textPrimary),
      displayMedium: NexifyTypography.headlineMedium.copyWith(color: NexifyColors.textPrimary),
      headlineLarge: NexifyTypography.headlineLarge.copyWith(color: NexifyColors.textPrimary),
      headlineMedium: NexifyTypography.headlineMedium.copyWith(color: NexifyColors.textPrimary),
      titleLarge: NexifyTypography.titleLarge.copyWith(color: NexifyColors.textPrimary),
      titleMedium: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary),
      bodyLarge: NexifyTypography.bodyLarge.copyWith(color: NexifyColors.textSecondary),
      bodyMedium: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textSecondary),
      bodySmall: NexifyTypography.bodySmall.copyWith(color: NexifyColors.textMuted),
      labelLarge: NexifyTypography.labelLarge.copyWith(color: NexifyColors.textPrimary),
      labelMedium: NexifyTypography.labelMedium.copyWith(color: NexifyColors.textSecondary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NexifyColors.background,
      primaryColor: NexifyColors.brandPrimary,
      colorScheme: const ColorScheme.dark(
        primary: NexifyColors.brandPrimary,
        secondary: NexifyColors.brandPrimaryDark,
        surface: NexifyColors.backgroundSurface,
        onSurface: NexifyColors.textPrimary,
        onPrimary: NexifyColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: NexifyColors.background,
        foregroundColor: NexifyColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: textTheme,
      dividerTheme: const DividerThemeData(
        color: NexifyColors.border,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: NexifyColors.textPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NexifyColors.backgroundSurface,
        contentTextStyle: NexifyTypography.bodyMedium.copyWith(
          color: NexifyColors.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NexifyRadius.sm),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: NexifyColors.brandPrimary,
        foregroundColor: NexifyColors.background,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NexifyColors.backgroundElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NexifyRadius.md),
          borderSide: const BorderSide(color: NexifyColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NexifyRadius.md),
          borderSide: const BorderSide(color: NexifyColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NexifyRadius.md),
          borderSide: const BorderSide(color: NexifyColors.brandPrimary),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        NexifyTokens(),
      ],
    );
  }
}

class NexifyTokens extends ThemeExtension<NexifyTokens> {
  const NexifyTokens();

  Color get brandPrimary => NexifyColors.brandPrimary;
  Color get surface => NexifyColors.backgroundSurface;
  Color get surfaceElevated => NexifyColors.backgroundElevated;
  Color get border => NexifyColors.border;
  Color get textPrimary => NexifyColors.textPrimary;
  Color get textSecondary => NexifyColors.textSecondary;
  double get spacingXs => NexifySpacing.xs;
  double get spacingMd => NexifySpacing.md;
  double get radiusMd => NexifyRadius.md;
  List<BoxShadow> get cardShadow => NexifyShadows.card;
  Duration get motionStandard => NexifyMotion.standard;

  @override
  NexifyTokens copyWith({
    Color? brandPrimary,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    double? spacingXs,
    double? spacingMd,
    double? radiusMd,
    List<BoxShadow>? cardShadow,
    Duration? motionStandard,
  }) {
    return NexifyTokens();
  }

  @override
  NexifyTokens lerp(ThemeExtension<NexifyTokens>? other, double t) {
    if (other is! NexifyTokens) {
      return this;
    }
    return NexifyTokens();
  }
}
