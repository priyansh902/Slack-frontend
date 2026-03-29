import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg        = Color(0xFF0B0C12);
  static const surface   = Color(0xFF13141E);
  static const card      = Color(0xFF1A1C28);
  static const border    = Color(0xFF252736);
  static const accent    = Color(0xFF7B6EF6);
  static const accentLo  = Color(0x267B6EF6);
  static const cyan      = Color(0xFF00CFFF);
  static const success   = Color(0xFF22C55E);
  static const error     = Color(0xFFFF4C6A);
  static const warning   = Color(0xFFF59E0B);
  static const textPri   = Color(0xFFF1F1FF);
  static const textSec   = Color(0xFF8B90A8);
  static const textHint  = Color(0xFF545770);

  static const lBg       = Color(0xFFF4F4FF);
  static const lSurface  = Color(0xFFFFFFFF);
  static const lCard     = Color(0xFFFAFAFF);
  static const lBorder   = Color(0xFFE2E2EF);
  static const lTextPri  = Color(0xFF14152A);
  static const lTextSec  = Color(0xFF6B6E8B);

  static List<Color> avatarGradient(String seed) {
    final h = seed.hashCode % 360;
    final s = HSLColor.fromAHSL(1, h.toDouble(), 0.65, 0.55);
    final e = HSLColor.fromAHSL(1, (h + 40) % 360, 0.65, 0.45);
    return [s.toColor(), e.toColor()];
  }
}

class AppTheme {
  static SystemUiOverlayStyle get darkOverlay => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static SystemUiOverlayStyle get lightOverlay => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.cyan,
        surface: AppColors.surface,
        onSurface: AppColors.textPri,
        outline: AppColors.border,
        error: AppColors.error,
      ),
      textTheme: _textTheme(dark: true),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: darkOverlay,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPri),
        iconTheme: const IconThemeData(color: AppColors.textPri, size: 22),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.accentLo,
        height: 64,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500)),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? AppColors.accent : AppColors.textSec,
          size: 22,
        )),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: _inputTheme(dark: true),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.card,
        side: const BorderSide(color: AppColors.border),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPri),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSec,
        textColor: AppColors.textPri,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.accent : AppColors.textHint),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.accentLo : AppColors.border),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.card,
        contentTextStyle: GoogleFonts.inter(color: AppColors.textPri, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.cyan,
        surface: AppColors.lSurface,
        onSurface: AppColors.lTextPri,
        outline: AppColors.lBorder,
        error: AppColors.error,
      ),
      textTheme: _textTheme(dark: false),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lBg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: lightOverlay,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lTextPri),
        iconTheme: const IconThemeData(color: AppColors.lTextPri, size: 22),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: _inputTheme(dark: false),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lCard,
        side: const BorderSide(color: AppColors.lBorder),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.lTextPri),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.lBorder, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lCard,
        contentTextStyle: GoogleFonts.inter(color: AppColors.lTextPri, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _textTheme({required bool dark}) {
    final pri = dark ? AppColors.textPri : AppColors.lTextPri;
    final sec = dark ? AppColors.textSec : AppColors.lTextSec;
    return TextTheme(
      displayLarge:  GoogleFonts.spaceGrotesk(fontSize: 34, fontWeight: FontWeight.w700, color: pri),
      headlineLarge: GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.w700, color: pri),
      headlineMedium:GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: pri),
      headlineSmall: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: pri),
      titleLarge:    GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: pri),
      titleMedium:   GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600, color: pri),
      titleSmall:    GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w500, color: pri),
      bodyLarge:     GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: pri),
      bodyMedium:    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: sec),
      bodySmall:     GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: sec),
      labelLarge:    GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600, color: pri),
      labelSmall:    GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: sec),
    );
  }

  static InputDecorationTheme _inputTheme({required bool dark}) {
    final fill = dark ? AppColors.card : AppColors.lSurface;
    final border = dark ? AppColors.border : AppColors.lBorder;
    final hint = dark ? AppColors.textHint : AppColors.lTextSec;
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      hintStyle: GoogleFonts.inter(color: hint, fontSize: 14),
      labelStyle: GoogleFonts.inter(color: hint, fontSize: 14),
      prefixIconColor: hint,
      suffixIconColor: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
    );
  }
}
