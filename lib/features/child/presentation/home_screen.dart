import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_child.dart';
import '../../../mocks/mock_badges.dart';
import '../../../mocks/mock_progress.dart';
import '../../../shared/widgets/arabic_text.dart';
import '../../../shared/widgets/nur_card.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/badge_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final child = mockChild;
    final badges = mockBadges;
    final progress = mockProgress;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(child: child).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: AppSpacing.md),

            // Devam Et kartı
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ContinueCard(progress: progress),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.15),

            const SizedBox(height: AppSpacing.lg),

            // Keşfet grid
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('Keşfet', style: AppTextStyles.titleLarge),
            ),

            const SizedBox(height: AppSpacing.sm),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ModuleGrid(progress: progress),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),

            const SizedBox(height: AppSpacing.lg),

            // Rozetler başlığı
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rozetlerim', style: AppTextStyles.titleLarge),
                  GestureDetector(
                    onTap: () => context.go('/child/badges'),
                    child: Text(
                      'Tümü →',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md),
                itemCount: badges.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final b = badges[i];
                  return BadgeCard(
                    icon: b['icon'] as String,
                    nameTr: b['nameTr'] as String,
                    earned: b['earned'] as bool,
                  );
                },
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.child});

  final Map<String, dynamic> child;

  @override
  Widget build(BuildContext context) {
    final name = child['name'] as String;
    final streak = child['streakDays'] as int;
    final ayahsDone = child['todayAyahsCompleted'] as int;
    final ayahsGoal = child['todayAyahsGoal'] as int;
    final minDone = child['todayMinutes'] as int;
    final minGoal = child['dailyGoalMinutes'] as int;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merhaba, $name! ✨',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Bugün $minDone/$minGoal dk tamamlandı',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Ebeveyn butonu
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.go('/parent/dashboard');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.supervisor_account_rounded,
                          color: AppColors.white, size: 20),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  // Streak badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 4),
                        Text(
                          '$streak gün',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Günlük hedef kartı
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Günlük Hedef',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.white),
                        ),
                        Text(
                          '$ayahsDone/$ayahsGoal Ayet',
                          style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: ayahsDone / ayahsGoal,
                        minHeight: 10,
                        backgroundColor:
                            AppColors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Devam Et kartı ──────────────────────────────────────────────────────────

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.progress});

  final Map<String, dynamic> progress;

  @override
  Widget build(BuildContext context) {
    final completed = progress['surahsCompleted'] as int;
    final total = progress['surahsTotal'] as int;

    return NurCard(
      onTap: () => context.go('/child/surahs/al-fatiha'),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Sol: bilgi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Devam Et',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.primary, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Al-Fatiha Sûresi',
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: 2),
                ArabicText(
                  'الفاتحة',
                  fontSize: 20,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: AppSpacing.sm),
                ProgressBar(value: 3 / 7),
                const SizedBox(height: 4),
                Text(
                  '$completed/$total Sure tamamlandı',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Sağ: ikon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('📖', style: TextStyle(fontSize: 32)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 2×2 Modül grid ──────────────────────────────────────────────────────────

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({required this.progress});

  final Map<String, dynamic> progress;

  @override
  Widget build(BuildContext context) {
    final modules = [
      _ModuleItem(
        emoji: '📖',
        title: 'Sureler',
        stat:
            '${progress['surahsCompleted']}/${progress['surahsTotal']} tamamlandı',
        bgColor: AppColors.primaryBg,
        accentColor: AppColors.primary,
        route: '/child/surahs',
        locked: false,
      ),
      _ModuleItem(
        emoji: '🤲',
        title: 'Dualar',
        stat:
            '${progress['duasLearned']}/${progress['duasTotal']} öğrenildi',
        bgColor: AppColors.duaBg,
        accentColor: AppColors.dua,
        route: '/child/duas',
        locked: false,
      ),
      _ModuleItem(
        emoji: '⭐',
        title: 'Quiz',
        stat: 'Oyna!',
        bgColor: AppColors.quizBg,
        accentColor: AppColors.quiz,
        route: '/child/surahs',
        locked: false,
      ),
      _ModuleItem(
        emoji: '📚',
        title: 'Kıssalar',
        stat: 'Pro',
        bgColor: AppColors.rewardBg,
        accentColor: AppColors.reward,
        route: '/child/stories',
        locked: true,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: modules.map((m) => _ModuleCard(item: m)).toList(),
    );
  }
}

class _ModuleItem {
  const _ModuleItem({
    required this.emoji,
    required this.title,
    required this.stat,
    required this.bgColor,
    required this.accentColor,
    required this.route,
    required this.locked,
  });

  final String emoji;
  final String title;
  final String stat;
  final Color bgColor;
  final Color accentColor;
  final String route;
  final bool locked;
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.item});

  final _ModuleItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(item.route),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: item.bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.emoji,
                    style: const TextStyle(fontSize: 32)),
                if (item.locked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_rounded,
                            size: 11, color: item.accentColor),
                        const SizedBox(width: 3),
                        Text(
                          'Pro',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              item.title,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 2),
            Text(
              item.stat,
              style: AppTextStyles.labelSmall.copyWith(
                color: item.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
