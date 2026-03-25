import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/screens/auth/login_screen.dart';
import 'package:phoenix_slack/screens/auth/register_screen.dart';
import 'package:phoenix_slack/screens/home/home_screen.dart';
import 'package:phoenix_slack/screens/portfolio/portfolio_screen.dart';
import 'package:phoenix_slack/screens/profile/edit_profile_screen.dart';
import 'package:phoenix_slack/screens/profile/my_profile_screen.dart';
import 'package:phoenix_slack/screens/profile/user_profile_screen.dart';
import 'package:phoenix_slack/screens/projects/create_project_screen.dart';
import 'package:phoenix_slack/screens/projects/project_detail_screen.dart';
import 'package:phoenix_slack/screens/projects/projects_screen.dart';
import 'package:phoenix_slack/screens/resume/resume_screen.dart';
import 'package:phoenix_slack/screens/search/search_screen.dart';
import 'package:phoenix_slack/screens/settings/account_settings.dart';
import 'package:phoenix_slack/screens/settings/settings_screen.dart';
import 'package:phoenix_slack/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: DevConnectApp(),
    ),
  );
}

class DevConnectApp extends ConsumerWidget {
  const DevConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
      title: 'Phoenix Slack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: authState.isAuthenticated ? const HomeScreen() : const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const MyProfileScreen());
          case '/profile/edit':
            return MaterialPageRoute(builder: (_) => const EditProfileScreen());
          case '/profile/user':
            final args = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => UserProfileScreen(username: args),
            );
          case '/projects':
            return MaterialPageRoute(builder: (_) => const ProjectsScreen());
          case '/project':
            final projectId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => ProjectDetailScreen(projectId: projectId),
            );
          case '/projects/create':
            return MaterialPageRoute(builder: (_) => const CreateProjectScreen());
          // case '/projects/edit':
          //   final project = settings.arguments;
          //   return MaterialPageRoute(
          //     builder: (_) => EditProjectScreen(project: project),
          //   );
          case '/resume':
            return MaterialPageRoute(builder: (_) => const ResumeScreen());
          case '/search':
            return MaterialPageRoute(builder: (_) => const SearchScreen());
          case '/portfolio':
            final username = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => PortfolioScreen(username: username),
            );
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/settings/account':
            return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
          default:
            return null;
        }
      },
    );
  }
}