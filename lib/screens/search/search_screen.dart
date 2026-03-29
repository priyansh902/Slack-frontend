import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/providers/search_provider.dart';
import 'package:phoenix_slack/screens/search/widgets/search_reult_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override ConsumerState<SearchScreen> createState() => _S();
}

class _S extends ConsumerState<SearchScreen> {
  final _ctrl  = TextEditingController();
  final _focus = FocusNode();
  String _type = 'keyword';

  @override
  void initState() {
    super.initState();
    // Rebuild when focus changes so border color updates
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _search([String? _]) {
    final q = _ctrl.text.trim();
    if (q.length < 2) {
      ref.read(searchNotifierProvider.notifier).clear();
      return;
    }
    final n = ref.read(searchNotifierProvider.notifier);
    switch (_type) {
      case 'username': n.searchByUsername(q);
      case 'name':     n.searchByName(q);
      default:         n.searchByKeyword(q);
    }
  }

  void _clear() {
    _ctrl.clear();
    ref.read(searchNotifierProvider.notifier).clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchNotifierProvider);
    final recent  = ref.watch(recentUsersProvider);
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final isEmpty = _ctrl.text.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header & search bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Search',
                style: GoogleFonts.spaceGrotesk(fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 14),

              // Search field
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isDark ? AppColors.card : Colors.white,
                  border: Border.all(
                    color: _focus.hasFocus
                      ? AppColors.accent
                      : (isDark ? AppColors.border : AppColors.lBorder),
                    width: _focus.hasFocus ? 1.5 : 1),
                ),
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                  onChanged: (v) {
                    setState(() {});
                    if (v.trim().length >= 2) _search();
                    if (v.isEmpty) ref.read(searchNotifierProvider.notifier).clear();
                  },
                  style: GoogleFonts.inter(fontSize: 14,
                    color: isDark ? AppColors.textPri : AppColors.lTextPri),
                  decoration: InputDecoration(
                    hintText: 'Search developers...',
                    hintStyle: GoogleFonts.inter(
                      color: isDark ? AppColors.textHint : AppColors.lTextSec),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20,
                      color: AppColors.textSec),
                    suffixIcon: _ctrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18,
                            color: AppColors.textSec),
                          onPressed: _clear)
                      : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  ),
                ),
              ).animate().fadeIn(delay: 80.ms),

              const SizedBox(height: 10),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _Chip(label: 'All', icon: Icons.tag_rounded,
                    sel: _type == 'keyword', isDark: isDark,
                    onTap: () { setState(() => _type = 'keyword'); _search(); }),
                  const SizedBox(width: 8),
                  _Chip(label: 'Username', icon: Icons.alternate_email_rounded,
                    sel: _type == 'username', isDark: isDark,
                    onTap: () { setState(() => _type = 'username'); _search(); }),
                  const SizedBox(width: 8),
                  _Chip(label: 'Name', icon: Icons.person_outline_rounded,
                    sel: _type == 'name', isDark: isDark,
                    onTap: () { setState(() => _type = 'name'); _search(); }),
                ]),
              ).animate().fadeIn(delay: 140.ms),

              const SizedBox(height: 12),
            ]),
          ),

          // ── Results / Recent ──────────────────────────────────────────
          Expanded(child: results.when(
            data: (list) {
              // Show results when searching
              if (!isEmpty) {
                if (list.isEmpty) return _NoResults(isDark: isDark);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: list.length,
                  itemBuilder: (_, i) => SearchResultCard(result: list[i])
                    .animate().fadeIn(delay: (i * 40).ms, duration: 250.ms),
                );
              }
              // Show recent users when idle
              return recent.when(
                data: (users) {
                  if (users.isEmpty) return _IdleHint(isDark: isDark);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Text('Recently joined',
                          style: GoogleFonts.spaceGrotesk(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSec : AppColors.lTextSec)),
                      ),
                      Expanded(child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: users.length,
                        itemBuilder: (_, i) => SearchResultCard(result: users[i])
                          .animate().fadeIn(delay: (i * 40).ms),
                      )),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
                error: (_, __) => _IdleHint(isDark: isDark),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.accent)),
            error: (e, _) => Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.error),
                const SizedBox(height: 10),
                Text('Search failed', style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri)),
                const SizedBox(height: 4),
                Text(e.toString(), style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
              ])),
          )),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label; final IconData icon;
  final bool sel, isDark; final VoidCallback onTap;
  const _Chip({required this.label, required this.icon,
    required this.sel, required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: sel ? AppColors.accent : (isDark ? AppColors.card : AppColors.lCard),
        border: Border.all(
          color: sel ? AppColors.accent : (isDark ? AppColors.border : AppColors.lBorder))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13,
          color: sel ? Colors.white : (isDark ? AppColors.textSec : AppColors.lTextSec)),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
          color: sel ? Colors.white : (isDark ? AppColors.textSec : AppColors.lTextSec))),
      ]),
    ),
  );
}

class _IdleHint extends StatelessWidget {
  final bool isDark; const _IdleHint({required this.isDark});
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(40),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 72, height: 72,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: isDark ? AppColors.card : AppColors.lCard),
        child: const Icon(Icons.search_rounded, size: 32, color: AppColors.accent)),
      const SizedBox(height: 16),
      Text('Find developers', style: GoogleFonts.spaceGrotesk(fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPri : AppColors.lTextPri)),
      const SizedBox(height: 4),
      Text('Search by keyword, username or name',
        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
    ]),
  ));
}

class _NoResults extends StatelessWidget {
  final bool isDark; const _NoResults({required this.isDark});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.search_off_rounded, size: 48,
      color: isDark ? AppColors.textSec : AppColors.lTextSec),
    const SizedBox(height: 12),
    Text('No developers found', style: GoogleFonts.spaceGrotesk(fontSize: 15,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textPri : AppColors.lTextPri)),
    const SizedBox(height: 4),
    Text('Try a different term', style: Theme.of(context).textTheme.bodyMedium),
  ]));
}
