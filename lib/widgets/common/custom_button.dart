import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: textColor ?? Theme.of(context).primaryColor,
            minimumSize: Size(width ?? double.infinity, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
            foregroundColor: textColor ?? Colors.white,
            minimumSize: Size(width ?? double.infinity, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );

    if (isLoading) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: isOutlined
            ? OutlinedButton(
                onPressed: null,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : ElevatedButton(
                onPressed: null,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
      );
    }

    if (icon != null) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: isOutlined
            ? OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(text),
                style: buttonStyle,
              )
            : ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(text),
                style: buttonStyle,
              ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: Text(text),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: Text(text),
            ),
    );
  }
}