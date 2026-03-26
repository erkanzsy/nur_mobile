import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_surahs.dart';
import '../../../mocks/mock_progress.dart';
import '../../../shared/widgets/arabic_text.dart';
import '../../../shared/widgets/locked_content_sheet.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/star_rating.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surahs = mockSurahs;
    final completed = mockProgress['surahsCompleted'] as int;
    final total = mockProgress['surahsTotal'] as int;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _SurahListHeader(completed: completed, total: total),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: surahs.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) => _SurahCard(
                surah: surahs[i],
                index: i,
              ).animate().fadeIn(delay: (i * 60).ms).slideX(begin: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _SurahListHeader extends StatelessWidget {
  const _SurahListHeader({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg,
          ),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sureler',
                      style: AppTextStyles.headlineLarge
                          .copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completed/$total sure tamamlandı',
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              // Progress donut gösterge
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: completed / total,
                      backgroundColor:
                          AppColors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(AppColors.white),
                      strokeWidth: 5,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '$completed/$total',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Surah Card ──────────────────────────────────────────────────────────────

class _SurahCard extends StatelessWidget {
  const _SurahCard({required this.surah, required this.index});

  final Map<String, dynamic> surah;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = surah['isUnlocked'] as bool;
    final progress = surah['progress'] as double;
    final stars = surah['starsEarned'] as int;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          context.go('/child/surahs/${surah['id']}');
        } else {
          LockedContentSheet.show(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.white : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: const Color(0xFF2C2C2A).withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Numara / kilit
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.primaryBg : AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        '${index + 1}',
                        style: AppTextStyles.titleMedium
                            .copyWith(color: AppColors.primary),
                      )
                    : const Icon(Icons.lock_rounded,
                        color: AppColors.textMuted, size: 18),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // İsimler + progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArabicText(
                        surah['nameAr'] as String,
                        fontSize: 18,
                        color: isUnlocked
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                      if (isUnlocked && stars > 0)
                        StarRating(stars: stars, size: 16),
                      if (!isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Pro',
                            style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textMuted),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${surah['nameTr']} • ${surah['ayahCount']} Ayet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (isUnlocked && progress > 0) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ProgressBar(value: progress),
                  ],
                ],
              ),
            ),

            if (isUnlocked) ...[
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
            ],
          ],
        ),
      ),
    );
  }
}
