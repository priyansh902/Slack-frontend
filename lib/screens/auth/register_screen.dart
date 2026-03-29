import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/user/user.dart';
import 'package:phoenix_slack/providers/auth_provider.dart';
import 'package:phoenix_slack/widgets/common/app_button.dart';
import 'package:phoenix_slack/widgets/common/app_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override ConsumerState<RegisterScreen> createState() => _S();
}
class _S extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _user = TextEditingController();
  final _email= TextEditingController();
  final _pass = TextEditingController();
  final _conf = TextEditingController();
  bool _hide = true, _loading = false;

  @override
  void dispose() {
    for (final c in [_name,_user,_email,_pass,_conf]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await ref.read(authStateProvider.notifier).register(
      RegisterRequest(name: _name.text.trim(), username: _user.text.trim(),
        email: _email.text.trim(), password: _pass.text));
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final err = ref.read(authStateProvider).error ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Form(key: _form, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder),
                  ),
                  child: Icon(Icons.arrow_back_rounded, size: 18,
                    color: isDark ? AppColors.textPri : AppColors.lTextPri),
                ),
                padding: EdgeInsets.zero, constraints: const BoxConstraints(),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 24),
              Text('Create\naccount.',
                style: GoogleFonts.spaceGrotesk(fontSize: 36, fontWeight: FontWeight.w700, height: 1.1,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri),
              ).animate().fadeIn(delay: 80.ms).slideX(begin: -0.15),
              const SizedBox(height: 6),
              Text('Join the dev community',
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 140.ms),
              const SizedBox(height: 30),
              ..._fields().asMap().entries.map((e) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: e.value.animate().fadeIn(delay: (200 + e.key * 55).ms),
                ),
              ),
              const SizedBox(height: 18),
              AppButton(text: 'Create Account', onPressed: _register, isLoading: _loading)
                .animate().fadeIn(delay: 520.ms),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Already have an account?', style: Theme.of(context).textTheme.bodyMedium),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(horizontal: 6)),
                  child: Text('Sign In',
                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ]).animate().fadeIn(delay: 560.ms),
            ],
          )),
        ),
      ),
    );
  }

  List<Widget> _fields() => [
    AppField(controller: _name, label: 'Full name', hint: 'John Doe',
      icon: Icons.person_outline_rounded,
      validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null),
    AppField(controller: _user, label: 'Username', hint: 'johndoe',
      icon: Icons.alternate_email_rounded,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Username required';
        if (v.length < 3) return 'Minimum 3 characters';
        return null;
      }),
    AppField(controller: _email, label: 'Email', hint: 'you@example.com',
      icon: Icons.mail_outline_rounded, keyboard: TextInputType.emailAddress,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Email is required';
        if (!v.contains('@')) return 'Enter a valid email';
        return null;
      }),
    AppField(controller: _pass, label: 'Password', hint: '••••••••',
      icon: Icons.lock_outline_rounded, obscure: _hide,
      suffix: IconButton(
        icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
        onPressed: () => setState(() => _hide = !_hide),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Password required';
        if (v.length < 6) return 'Minimum 6 characters';
        return null;
      }),
    AppField(controller: _conf, label: 'Confirm password', hint: '••••••••',
      icon: Icons.lock_outline_rounded, obscure: _hide,
      validator: (v) => (v != _pass.text) ? 'Passwords do not match' : null),
  ];
}
