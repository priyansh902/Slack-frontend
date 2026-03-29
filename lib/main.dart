import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/screens/admin/admin_dashboard.dart';
import 'package:phoenix_slack/screens/auth/login_screen.dart';
import 'package:phoenix_slack/screens/auth/register_screen.dart';
import 'package:phoenix_slack/screens/home/home_screen.dart';
import 'package:phoenix_slack/screens/portfolio/portfolio_screen.dart';
import 'package:phoenix_slack/screens/profile/edit_profile_screen.dart';
import 'package:phoenix_slack/screens/profile/my_profile_screen.dart';
import 'package:phoenix_slack/screens/profile/user_profile_screen.dart';
import 'package:phoenix_slack/screens/projects/create_project_screen.dart';
import 'package:phoenix_slack/screens/projects/edit_project_screen.dart';
import 'package:phoenix_slack/screens/projects/project_detail_screen.dart';
import 'package:phoenix_slack/screens/projects/projects_screen.dart';
import 'package:phoenix_slack/screens/resume/resume_screen.dart';
import 'package:phoenix_slack/screens/search/search_screen.dart';
import 'package:phoenix_slack/screens/settings/account_settings.dart';
import 'package:phoenix_slack/screens/settings/settings_screen.dart';
import 'package:phoenix_slack/screens/splash/splash_screen.dart';
import 'package:phoenix_slack/data/model/project/project.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: DevConnectApp()));
}

class DevConnectApp extends ConsumerWidget {
  const DevConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'DevConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: authState.isAuthenticated ? const HomeScreen() : const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return _route(const LoginScreen());
          case '/register':
            return _route(const RegisterScreen());
          case '/home':
            return _route(const HomeScreen());
          case '/profile':
            return _route(const MyProfileScreen());
          case '/profile/edit':
            return _route(const EditProfileScreen());
          case '/profile/user':
            // Arguments can be Map {userId, name} or legacy String (username)
            final args = settings.arguments;
            if (args is Map) {
              return _route(UserProfileScreen(
                userId: args['userId'] as int,
                displayName: args['name'] as String?));
            } else if (args is int) {
              return _route(UserProfileScreen(userId: args));
            } else {
              // Legacy: shouldn't happen but handle gracefully
              return _route(const UserProfileScreen(userId: 0));
            }
          case '/projects':
            return _route(const ProjectsScreen());
          case '/project':
            final id = settings.arguments as int;
            return _route(ProjectDetailScreen(projectId: id));
          case '/projects/create':
            return _route(const CreateProjectScreen());
          case '/projects/edit':
            final project = settings.arguments as Project;
            return _route(EditProjectScreen(project: project));
          case '/resume':
            return _route(const ResumeScreen());
          case '/search':
            return _route(const SearchScreen());
          case '/portfolio':
            final username = settings.arguments as String;
            return _route(PortfolioScreen(username: username));
          case '/settings':
            return _route(const SettingsScreen());
          case '/settings/account':
            return _route(const AccountSettingsScreen());
          case '/admin':
            return _route(const AdminDashboard());
          default:
            return _route(const SplashScreen());
        }
      },
    );
  }

  MaterialPageRoute _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}
