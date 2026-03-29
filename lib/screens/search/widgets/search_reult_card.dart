import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoenix_slack/core/themes/app_theme.dart';
import 'package:phoenix_slack/data/model/search/search_result.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  const SearchResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Use name for avatar since username from backend = email
    final displayName = result.name.isNotEmpty ? result.name : 'User';
    final cols = AppColors.avatarGradient(displayName);
    final init = displayName[0].toUpperCase();

    return GestureDetector(
      // Navigate by userId — username field from backend = email, not actual username
      onTap: () => Navigator.pushNamed(context, '/profile/user',
        arguments: {'userId': result.userId, 'name': displayName}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.card : AppColors.lCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
        child: Row(children: [
          Container(width: 48, height: 48,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(colors: cols,
                begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Center(child: Text(init, style: GoogleFonts.spaceGrotesk(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(displayName,
                style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPri : AppColors.lTextPri),
                overflow: TextOverflow.ellipsis)),
              if (result.isYou) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accentLo,
                    borderRadius: BorderRadius.circular(6)),
                  child: Text('You', style: GoogleFonts.inter(
                    fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accent))),
              ],
            ]),
            if (result.bio != null && result.bio!.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(result.bio!, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 12,
                  color: isDark ? AppColors.textSec : AppColors.lTextSec)),
            ],
            if (result.hasProjects) ...[
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.lBorder)),
                child: Text('${result.projectCount} project${result.projectCount != 1 ? 's' : ''}',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSec : AppColors.lTextSec))),
            ],
          ])),
          Icon(Icons.arrow_forward_ios_rounded, size: 14,
            color: isDark ? AppColors.textHint : AppColors.lTextSec),
        ]),
      ),
    );
  }
}
