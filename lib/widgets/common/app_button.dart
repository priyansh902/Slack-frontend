import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final Color? color;
  final double height;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.color,
    this.height = 52,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
          label: isLoading
              ? _loader(context)
              : Text(text, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: color ?? AppColors.accent,
            side: BorderSide(color: color ?? AppColors.accent),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      );
    }
    final bg = color ?? AppColors.accent;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: (onPressed == null || isLoading)
              ? null
              : LinearGradient(
                  colors: [bg, Color.lerp(bg, Colors.purple, 0.4)!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: (onPressed == null || isLoading) ? bg.withOpacity(0.4) : null,
          boxShadow: (onPressed != null && !isLoading)
              ? [BoxShadow(color: bg.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))]
              : null,
        ),
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: icon != null ? Icon(icon, size: 18, color: Colors.white) : const SizedBox.shrink(),
          label: isLoading ? _loader(context) : Text(text, style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _loader(BuildContext context) => const SizedBox(
    width: 20, height: 20,
    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
  );
}
