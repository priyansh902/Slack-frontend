import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/widgets/common/app_button.dart';
import 'package:phoenix_slack/widgets/common/app_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override ConsumerState<LoginScreen> createState() => _S();
}
class _S extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _hide = true, _loading = false;

  @override void dispose() { _email.dispose(); _pass.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await ref.read(authStateProvider.notifier).login(_email.text.trim(), _pass.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final err = ref.read(authStateProvider).error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err), backgroundColor: AppColors.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(children: [
        Positioned(top: -100, right: -80,
          child: _Blob(size: 280, color: AppColors.accent.withOpacity(0.07))),
        Positioned(bottom: 80, left: -80,
          child: _Blob(size: 220, color: AppColors.cyan.withOpacity(0.05))),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Form(key: _form, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _LogoBadge().animate().fadeIn(duration: 500.ms).slideY(begin: -0.3),
                const SizedBox(height: 36),
                Text('Welcome\nback.',
                  style: GoogleFonts.spaceGrotesk(fontSize: 38, fontWeight: FontWeight.w700, height: 1.1,
                    color: isDark ? AppColors.textPri : AppColors.lTextPri),
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.15),
                const SizedBox(height: 8),
                Text('Sign in to your account',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate().fadeIn(delay: 180.ms),
                const SizedBox(height: 40),
                AppField(controller: _email, label: 'Email', hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded, keyboard: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ).animate().fadeIn(delay: 260.ms),
                const SizedBox(height: 16),
                AppField(controller: _pass, label: 'Password', hint: '••••••••',
                  icon: Icons.lock_outline_rounded, obscure: _hide,
                  suffix: IconButton(
                    icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ).animate().fadeIn(delay: 320.ms),
                const SizedBox(height: 32),
                AppButton(text: 'Sign In', onPressed: _login, isLoading: _loading)
                  .animate().fadeIn(delay: 380.ms),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account?", style: Theme.of(context).textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 6)),
                    child: Text('Sign Up',
                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ]).animate().fadeIn(delay: 440.ms),
              ],
            )),
          ),
        ),
      ]),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 56, height: 56,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [AppColors.accent, Color(0xFFB06EF6)],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
    ),
    child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 30),
  );
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
