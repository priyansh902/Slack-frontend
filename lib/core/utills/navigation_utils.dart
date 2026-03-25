import 'package:flutter/material.dart';

class NavigationUtils {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static Future<T?> push<T>(BuildContext context, String routeName, {dynamic arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }
  
  static Future<T?> pushReplacement<T>(BuildContext context, String routeName, {dynamic arguments}) {
    return Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }
  
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
  
  static void popUntilRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
  
  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, String routeName, {dynamic arguments}) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
  
  // Helper methods for common navigations
  static void goToLogin(BuildContext context) {
    pushAndRemoveUntil(context, '/login');
  }
  
  static void goToHome(BuildContext context) {
    pushAndRemoveUntil(context, '/home');
  }
  
  static void goToProfile(BuildContext context) {
    push(context, '/profile');
  }
  
  static void goToUserProfile(BuildContext context, String username) {
    push(context, '/profile/user', arguments: username);
  }
  
  static void goToProjectDetail(BuildContext context, int projectId) {
    push(context, '/project', arguments: projectId);
  }
  
  static void goToCreateProject(BuildContext context) {
    push(context, '/projects/create');
  }
  
  static void goToEditProject(BuildContext context, dynamic project) {
    push(context, '/projects/edit', arguments: project);
  }
  
  static void goToResume(BuildContext context) {
    push(context, '/resume');
  }
  
  static void goToSearch(BuildContext context) {
    push(context, '/search');
  }
  
  static void goToPortfolio(BuildContext context, String username) {
    push(context, '/portfolio', arguments: username);
  }
  
  static void goToSettings(BuildContext context) {
    push(context, '/settings');
  }
  
  static void goToAccountSettings(BuildContext context) {
    push(context, '/settings/account');
  }
}