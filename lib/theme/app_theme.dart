// lib/theme/matrix_theme.dart
import 'package:flutter/material.dart';

/// Matrix color palette
class MatrixColors {
  static const background = Color(0xFF0A0A0A);  // near-black
  static const surface    = Color(0xFF111213);
  static const onSurface  = Color(0xFFE0E0E0);
  static const primary    = Color(0xFF00FF41);  // Matrix green
  static const secondary  = Color(0xFF00B894);  // neon teal
  static const accent     = Color(0xFF7CFFCB);
  static const error      = Color(0xFFFF4D4D);
  static const codeTint   = Color(0xFF1A2F1A);  // subtle green wash
  static const outline    = Color(0xFF2A2D2E);
}

/// ThemeExtension for app-specific styling knobs (HUD, “code rain”, pills, etc.)
@immutable
class MatrixTheme extends ThemeExtension<MatrixTheme> {
  final TextStyle hudText;
  final TextStyle hudSubtle;
  final Color hudBackground;
  final Gradient codeRainGradient; // for subtle backgrounds
  final ShapeBorder pillShape;

  const MatrixTheme({
    required this.hudText,
    required this.hudSubtle,
    required this.hudBackground,
    required this.codeRainGradient,
    required this.pillShape,
  });

  @override
  MatrixTheme copyWith({
    TextStyle? hudText,
    TextStyle? hudSubtle,
    Color? hudBackground,
    Gradient? codeRainGradient,
    ShapeBorder? pillShape,
  }) {
    return MatrixTheme(
      hudText: hudText ?? this.hudText,
      hudSubtle: hudSubtle ?? this.hudSubtle,
      hudBackground: hudBackground ?? this.hudBackground,
      codeRainGradient: codeRainGradient ?? this.codeRainGradient,
      pillShape: pillShape ?? this.pillShape,
    );
  }

  @override
  ThemeExtension<MatrixTheme> lerp(ThemeExtension<MatrixTheme>? other, double t) {
    if (other is! MatrixTheme) return this;
    return MatrixTheme(
      hudText: TextStyle.lerp(hudText, other.hudText, t)!,
      hudSubtle: TextStyle.lerp(hudSubtle, other.hudSubtle, t)!,
      hudBackground: Color.lerp(hudBackground, other.hudBackground, t)!,
      codeRainGradient: LinearGradient.lerp(
        codeRainGradient as LinearGradient,
        other.codeRainGradient as LinearGradient,
        t,
      )!,
      pillShape: t < .5 ? pillShape : other.pillShape,
    );
  }
}

/// Primary Matrix dark ThemeData (Material 3)
final ThemeData matrixDarkTheme = _buildMatrixDarkTheme();

ThemeData _buildMatrixDarkTheme() {
  const cs = ColorScheme(
    brightness: Brightness.dark,
    primary: MatrixColors.primary,
    onPrimary: Colors.black,
    primaryContainer: Color(0xFF003A1A),
    onPrimaryContainer: MatrixColors.onSurface,

    secondary: MatrixColors.secondary,
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFF083A34),
    onSecondaryContainer: MatrixColors.onSurface,

    tertiary: MatrixColors.accent,
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFF0A2E2A),
    onTertiaryContainer: MatrixColors.onSurface,

    error: MatrixColors.error,
    onError: Colors.white,
    errorContainer: Color(0xFF400000),
    onErrorContainer: Colors.white,

    background: MatrixColors.background,
    onBackground: MatrixColors.onSurface,
    surface: MatrixColors.surface,
    onSurface: MatrixColors.onSurface,
    surfaceVariant: Color(0xFF161818),
    onSurfaceVariant: Color(0xFFB5B5B5),
    outline: MatrixColors.outline,
    outlineVariant: Color(0xFF2E3233),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFEAEAEA),
    onInverseSurface: Colors.black,
    inversePrimary: Color(0xFF00E637),
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: cs,
    scaffoldBackgroundColor: cs.background,
    canvasColor: cs.background,
    splashFactory: InkRipple.splashFactory,
    visualDensity: VisualDensity.standard,
  );

  final textTheme = base.textTheme.apply(
    bodyColor: cs.onSurface,
    displayColor: cs.onSurface,
    fontFamily: 'monospace', // optional: “jetbrains mono”, “roboto mono” if you add fonts
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: cs.background,
      foregroundColor: cs.onSurface,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      ),
      actionsIconTheme: IconThemeData(color: cs.primary),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: cs.surface,
      indicatorColor: cs.primary.withOpacity(.15),
      labelTextStyle: WidgetStateProperty.resolveWith((_) =>
          textTheme.labelMedium?.copyWith(letterSpacing: .3)),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: cs.primary,
      textColor: cs.onSurface,
      tileColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    cardTheme: CardThemeData(
      color: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),
    dividerTheme: DividerThemeData(color: cs.outline.withOpacity(.4)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cs.surface,
      hintStyle: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
      labelStyle: textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: cs.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: cs.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: cs.primary, width: 1.4),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.primary;
        return cs.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.primary.withOpacity(.35);
        return cs.surfaceVariant;
      }),
    ),
    iconTheme: IconThemeData(color: cs.onSurface),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: cs.primary,
      circularTrackColor: cs.outline,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cs.surface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: cs.onSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    extensions: [
      MatrixTheme(
        hudText: textTheme.bodyMedium!.copyWith(
          color: MatrixColors.primary,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        hudSubtle: textTheme.bodySmall!.copyWith(
          color: MatrixColors.primary.withOpacity(.75),
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        hudBackground: Colors.black.withOpacity(.70),
        codeRainGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x0000FF41), // transparent green
            Color(0x2200FF41), // faint
            Color(0x0000FF41),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        pillShape: const StadiumBorder(side: BorderSide(width: 1, color: MatrixColors.primary)),
      ),
    ],
  );
}

/// Helpers to read MatrixTheme extension
extension MatrixThemeX on BuildContext {
  MatrixTheme get mx => Theme.of(this).extension<MatrixTheme>()!;
}
