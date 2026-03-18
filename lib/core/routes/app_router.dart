import 'package:go_router/go_router.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/dashboard_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/projects/projects_screen.dart';
import '../../screens/projects/add_project_screen.dart';
import '../../screens/projects/edit_project_screen.dart';
import '../../screens/resume/resume_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/portfolio/public_portfolio_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/projects',
        name: 'projects',
        builder: (context, state) => const ProjectsScreen(),
      ),
      GoRoute(
        path: '/projects/add',
        name: 'addProject',
        builder: (context, state) => const AddProjectScreen(),
      ),
      GoRoute(
        path: '/projects/edit/:projectId',
        name: 'editProject',
        builder: (context, state) {
          final projectId = int.parse(state.pathParameters['projectId']!);
          return EditProjectScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/resume',
        name: 'resume',
        builder: (context, state) => const ResumeScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/portfolio/:username',
        name: 'publicPortfolio',
        builder: (context, state) {
          final username = state.pathParameters['username']!;
          return PublicPortfolioScreen(username: username);
        },
      ),
    ],
  );
}