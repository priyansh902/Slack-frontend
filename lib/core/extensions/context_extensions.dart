import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void push(Widget screen) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
  
  void pushReplacement(Widget screen) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
  
  void pop() => Navigator.pop(this);
}