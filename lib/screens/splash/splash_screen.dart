import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override ConsumerState<SplashScreen> createState() => _S();
}
class _S extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _init();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _init() async {
    // Give animations time to play
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    // Try to restore session from stored token
    await ref.read(authStateProvider.notifier).loadCurrentUser();
    if (!mounted) return;

    final auth = ref.read(authStateProvider);
    Navigator.pushReplacementNamed(context, auth.isAuthenticated ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: Center(
      child: FadeTransition(opacity: _fade,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 72, height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [AppColors.accent, Color(0xFFB06EF6)],
                begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 36)),
          const SizedBox(height: 20),
          Text('DevConnect', style: GoogleFonts.spaceGrotesk(
            fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textPri)),
          const SizedBox(height: 6),
          Text('Build. Share. Connect.', style: GoogleFonts.inter(
            fontSize: 15, color: AppColors.textSec)),
          const SizedBox(height: 48),
          const SizedBox(width: 24, height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent)),
        ]),
      ),
    ),
  );
}
