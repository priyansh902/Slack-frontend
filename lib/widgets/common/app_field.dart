import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';

class AppField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final Widget? suffix;
  final bool obscure;
  final int maxLines;
  final int? maxLength;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final void Function(String)? onSubmit;
  final bool readOnly;

  const AppField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.suffix,
    this.obscure = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboard = TextInputType.text,
    this.validator,
    this.onChange,
    this.onSubmit,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: obscure ? 1 : maxLines,
      maxLength: maxLength,
      keyboardType: keyboard,
      validator: validator,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      readOnly: readOnly,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: isDark ? AppColors.textPri : AppColors.lTextPri,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        suffixIcon: suffix,
      ),
    );
  }
}
