import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  // ── Radius scale ─────────────────────────────────────────────────────
  static const double radiusSm = 6;
  static const double radiusMd = 10;
  static const double radiusLg = 14;
  static const double radiusXl = 18;
  static const double radiusPill = 999;

  // ── Spacing scale ────────────────────────────────────────────────────
  static const double spaceXs = 8;
  static const double spaceSm = 12;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double space2xl = 48;

  // ── Content width ────────────────────────────────────────────────────
  static const double maxContentWidth = 1180;

  // ── Marblex-inspired palette ─────────────────────────────────────────
  // Deep dark backgrounds with violet/indigo primary
  static const Color background = Color(0xFF07071A); // very dark navy-black
  static const Color surface = Color(0xFF0D0D26); // dark navy surface
  static const Color surfaceAlt = Color(0xFF141436); // elevated surface
  static const Color border = Color(0xFF1E1E48); // purple-tinted border

  // Brand: electric violet — Marblex signature
  static const Color primary = Color(0xFF7B5CF5); // electric violet
  static const Color primaryDark = Color(0xFF5B3EDB); // deeper violet
  static const Color primaryLight = Color(0xFF9B80FF); // lighter violet

  // Accent: electric cyan — contrast highlight
  static const Color accent = Color(0xFF00E5FF);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Text
  static const Color onSurface = Color(0xFFCACBE8); // cool-white body text
  static const Color onSurfaceBright = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF8888AA); // muted blue-gray
  static const Color mutedDim = Color(0xFF5A5A7A); // dimmer

  // ── Gradients ────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F0F35), Color(0xFF07071A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Glow shadow ───────────────────────────────────────────────────────
  static List<BoxShadow> glowShadow({
    double opacity = 0.3,
    double blur = 24,
    Color color = primary,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }

  // ── Card decoration ───────────────────────────────────────────────────
  static BoxDecoration glassCard({
    double borderRadius = 14,
    bool showBorder = true,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: surface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(borderRadius),
      border: showBorder
          ? Border.all(color: borderColor ?? border, width: 1)
          : null,
    );
  }

  // ── Gradient card decoration (for elevated cards) ──────────────────────
  static BoxDecoration gradientCard({
    double borderRadius = 14,
    Color? borderColor,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          surface.withValues(alpha: 0.95),
          surfaceAlt.withValues(alpha: 0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor ?? border, width: 1),
    );
  }

  // ── Theme data ────────────────────────────────────────────────────────
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSurface: onSurface,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          // ── Display / Hero (Bebas Neue) ──
          displayLarge: GoogleFonts.bebasNeue(
            fontSize: 160,
            fontWeight: FontWeight.w400,
            color: onSurfaceBright,
            height: 0.85,
            letterSpacing: -1.0,
          ),
          displayMedium: GoogleFonts.bebasNeue(
            fontSize: 96,
            fontWeight: FontWeight.w400,
            color: onSurfaceBright,
            height: 0.9,
          ),
          // ── Section headings (Space Grotesk) ──
          headlineLarge: GoogleFonts.spaceGrotesk(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: onSurfaceBright,
            height: 1.15,
            letterSpacing: -0.5,
          ),
          headlineMedium: GoogleFonts.spaceGrotesk(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: onSurfaceBright,
            height: 1.2,
            letterSpacing: -0.3,
          ),
          headlineSmall: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: onSurfaceBright,
            letterSpacing: -0.2,
          ),
          titleLarge: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: onSurfaceBright,
          ),
          titleMedium: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: onSurface,
          ),
          bodyLarge: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: onSurface,
          ),
          bodyMedium: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: onSurface,
          ),
          bodySmall: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: muted,
          ),
          labelLarge: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: onSurfaceBright,
          ),
          // ── Mono labels / code / tags (Fira Code) ──
          labelSmall: GoogleFonts.firaCode(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.8,
            color: muted,
          ),
        ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.spaceGrotesk(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.spaceGrotesk(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: muted),
    ),
    cardTheme: CardThemeData(
      color: surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: primary.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: border.withValues(alpha: 0.8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: GoogleFonts.spaceGrotesk(color: mutedDim),
      labelStyle: GoogleFonts.spaceGrotesk(color: muted),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: border.withValues(alpha: 0.9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: error, width: 1.4),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: surface,
      modalBarrierColor: Colors.black87,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceAlt,
      contentTextStyle: GoogleFonts.spaceGrotesk(color: onSurfaceBright),
      actionTextColor: primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primary,
      selectionColor: primary.withValues(alpha: 0.28),
      selectionHandleColor: primary,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: primary),
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
  );

  static ThemeData get light => dark;
}
