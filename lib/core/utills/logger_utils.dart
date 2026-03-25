import 'package:flutter/foundation.dart';

class LoggerUtils {
  static void log(String message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }
  
  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[ERROR] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }
  
  static void info(String message) {
    log(message, tag: 'INFO');
  }
  
  static void warning(String message) {
    log(message, tag: 'WARNING');
  }
  
  static void api(String message) {
    log(message, tag: 'API');
  }
  
  static void auth(String message) {
    log(message, tag: 'AUTH');
  }
  
  static void network(String message) {
    log(message, tag: 'NETWORK');
  }
}