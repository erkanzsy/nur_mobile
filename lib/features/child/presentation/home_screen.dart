import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/name_provider.dart';
import '../../../mocks/mock_badges.dart';
import '../../../mocks/mock_progress.dart';
import '../../../mocks/mock_surahs.dart';
import '../../../shared/widgets/badge_card.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/weekly_bar_chart.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileType = ref.watch(profileProvider);

    if (profileType == ProfileType.adult) {
      return const _AdultHome();
    }
    return const _ChildHome();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CHILD HOME
// ═══════════════════════════════════════════════════════════════════════════════

class _ChildHome extends ConsumerWidget {
  const _ChildHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(nameProvider);
    final badges = mockBadges;
    final progress = mockProgress;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ────────────────────────────────────────────────
            _ChildHeader(userName: userName)
                .animate()
                .fadeIn(duration: 400.ms),

            const SizedBox(height: AppSpacing.md),

            // ─── 2×2 Modül grid ────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ChildModuleGrid(progress: progress),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

            const SizedBox(height: AppSpacing.md),

            // ─── Rozetlerim ────────────────────────────────────────────
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
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// ─── Child Header ─────────────────────────────────────────────────────────────

class _ChildHeader extends ConsumerWidget {
  const _ChildHeader({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const streak = 7;
    const ayahsDone = 3;
    const ayahsGoal = 5;
    const minDone = 12;
    const minGoal = 20;

    final greeting =
        userName.isNotEmpty ? 'Merhaba, $userName! ✨' : 'Merhaba! ✨';

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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Bugün $minDone/$minGoal dk',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Ayarlar → parent dashboard
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
                      child: const Icon(Icons.settings_outlined,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Streak
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
                            style: TextStyle(fontSize: 16)),
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

              // Günlük hedef
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Günlük Hedef',
                                style: AppTextStyles.labelLarge
                                    .copyWith(color: AppColors.white),
                              ),
                              Text(
                                '$ayahsDone/$ayahsGoal Ayet',
                                style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.white
                                        .withValues(alpha: 0.85)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: ayahsDone / ayahsGoal,
                              minHeight: 8,
                              backgroundColor:
                                  AppColors.white.withValues(alpha: 0.3),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      AppColors.white),
                            ),
                          ),
                        ],
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

// ─── Child Module Grid ────────────────────────────────────────────────────────

class _ChildModuleGrid extends StatelessWidget {
  const _ChildModuleGrid({required this.progress});

  final Map<String, dynamic> progress;

  @override
  Widget build(BuildContext context) {
    // İlerleme olan sure — Sureler kartında progress göstermek için
    final inProgressSurah = mockSurahs
        .where((s) =>
            (s['progress'] as double) > 0 &&
            (s['progress'] as double) < 1.0)
        .firstOrNull;

    return Column(
      children: [
        // Üst sıra: Sureler + Dualar
        Row(
          children: [
            Expanded(
              child: _ChildModuleCard(
                emoji: '📖',
                title: 'Sureler',
                stat: '${progress['surahsCompleted']}/${progress['surahsTotal']} tamamlandı',
                bgColor: AppColors.primaryBg,
                accentColor: AppColors.primary,
                route: '/child/surahs',
                progressValue: inProgressSurah != null
                    ? inProgressSurah['progress'] as double
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ChildModuleCard(
                emoji: '🤲',
                title: 'Dualar',
                stat: '${progress['duasLearned']}/${progress['duasTotal']} öğrenildi',
                bgColor: AppColors.duaBg,
                accentColor: AppColors.dua,
                route: '/child/duas',
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        // Alt sıra: Elif-Ba + Kıssalar
        Row(
          children: [
            Expanded(
              child: _ChildModuleCard(
                emoji: 'أ',
                title: 'Elif-Ba',
                stat: '2/28 harf',
                bgColor: AppColors.quizBg,
                accentColor: AppColors.quiz,
                route: '/child/hareke',
                isArabicEmoji: true,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ChildModuleCard(
                emoji: '📚',
                title: 'Kıssalar',
                stat: '${progress['storiesCompleted']}/${progress['storiesTotal']} kıssa',
                bgColor: AppColors.rewardBg,
                accentColor: AppColors.reward,
                route: '/child/stories',
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        // Tam genişlik: Hadis
        _ChildModuleCardWide(
          emoji: '📜',
          title: 'Hadis & Sünnet',
          stat: 'Hadis ezberi',
          bgColor: AppColors.coralBg,
          accentColor: AppColors.coral,
          route: '/child/hadith',
        ),
      ],
    );
  }
}

class _ChildModuleCard extends StatelessWidget {
  const _ChildModuleCard({
    required this.emoji,
    required this.title,
    required this.stat,
    required this.bgColor,
    required this.accentColor,
    required this.route,
    this.progressValue,
    this.isArabicEmoji = false,
  });

  final String emoji;
  final String title;
  final String stat;
  final Color bgColor;
  final Color accentColor;
  final String route;
  final double? progressValue;
  final bool isArabicEmoji;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.go(route);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isArabicEmoji
                ? Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 28,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(emoji,
                    style: const TextStyle(fontSize: 28)),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 2),
            Text(
              stat,
              style: AppTextStyles.labelSmall
                  .copyWith(color: accentColor),
            ),
            if (progressValue != null) ...[
              const SizedBox(height: 8),
              ProgressBar(value: progressValue!, color: accentColor),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChildModuleCardWide extends StatelessWidget {
  const _ChildModuleCardWide({
    required this.emoji,
    required this.title,
    required this.stat,
    required this.bgColor,
    required this.accentColor,
    required this.route,
  });

  final String emoji;
  final String title;
  final String stat;
  final Color bgColor;
  final Color accentColor;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.go(route);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMedium),
                  Text(
                    stat,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: accentColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ADULT HOME
// ═══════════════════════════════════════════════════════════════════════════════

class _AdultHome extends ConsumerWidget {
  const _AdultHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(nameProvider);
    final progress = mockProgress;
    final thisWeek = {
      'totalMinutes': 95,
      'dailyMinutes': [8, 15, 12, 20, 18, 10, 12],
    };
    final dailyMinutes =
        (thisWeek['dailyMinutes'] as List).cast<int>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ──────────────────────────────────────────────
            _AdultHeader(userName: userName)
                .animate()
                .fadeIn(duration: 400.ms),

            const SizedBox(height: AppSpacing.md),

            // ─── 3'lü istatistik ─────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  _StatChip(
                    icon: '⏱',
                    label: 'Bu hafta',
                    value: '${thisWeek['totalMinutes']} dk',
                    color: AppColors.primaryBg,
                    accentColor: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatChip(
                    icon: '📖',
                    label: 'Sureler',
                    value:
                        '${progress['surahsCompleted']}/${progress['surahsTotal']}',
                    color: AppColors.primaryBg,
                    accentColor: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatChip(
                    icon: '⭐',
                    label: 'Yıldızlar',
                    value: '${progress['totalStars']}',
                    color: AppColors.rewardBg,
                    accentColor: AppColors.reward,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: AppSpacing.lg),

            // ─── Haftalık grafik ─────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bu Hafta',
                          style: AppTextStyles.titleLarge),
                      Text(
                        '${thisWeek['totalMinutes']} dk toplam',
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 120,
                    child: WeeklyBarChart(
                      data: dailyMinutes,
                      todayIndex: 6,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: AppSpacing.lg),

            // ─── İçerik erişimi ──────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('İçerik', style: AppTextStyles.titleLarge),
            ),
            const SizedBox(height: AppSpacing.sm),

            _ContentList(progress: progress)
                .animate()
                .fadeIn(delay: 300.ms),

            const SizedBox(height: AppSpacing.lg),

            // ─── Ayarlar kısayolu ────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _SettingsShortcut(),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// ─── Adult Header ─────────────────────────────────────────────────────────────

class _AdultHeader extends ConsumerWidget {
  const _AdultHeader({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting =
        userName.isNotEmpty ? 'Hoş Geldiniz, $userName' : 'Hoş Geldiniz';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.parent,
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Yetişkin modu • İlerleme takibi',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Mod değiştir
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(profileProvider.notifier).state =
                      ProfileType.child;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⭐',
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        'Çocuk Modu',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat Chip ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.accentColor,
  });

  final String icon;
  final String label;
  final String value;
  final Color color;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.titleLarge
                  .copyWith(color: accentColor),
            ),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}

// ─── Content List ─────────────────────────────────────────────────────────────

class _ContentList extends StatelessWidget {
  const _ContentList({required this.progress});

  final Map<String, dynamic> progress;

  @override
  Widget build(BuildContext context) {
    final items = [
      _ContentItem(
        emoji: '📖',
        title: 'Sureler',
        stat:
            '${progress['surahsCompleted']}/${progress['surahsTotal']} tamamlandı',
        route: '/child/surahs',
        progressValue: (progress['surahsCompleted'] as int) /
            (progress['surahsTotal'] as int),
        color: AppColors.primaryBg,
        accentColor: AppColors.primary,
      ),
      _ContentItem(
        emoji: '🤲',
        title: 'Dualar',
        stat:
            '${progress['duasLearned']}/${progress['duasTotal']} öğrenildi',
        route: '/child/duas',
        progressValue: (progress['duasLearned'] as int) /
            (progress['duasTotal'] as int),
        color: AppColors.duaBg,
        accentColor: AppColors.dua,
      ),
      _ContentItem(
        emoji: '📚',
        title: 'Kıssalar',
        stat:
            '${progress['storiesCompleted']}/${progress['storiesTotal']} kıssa',
        route: '/child/stories',
        progressValue: 0.0,
        color: AppColors.rewardBg,
        accentColor: AppColors.reward,
      ),
      _ContentItem(
        emoji: '📜',
        title: 'Hadis & Sünnet',
        stat: 'Hadis ezberi',
        route: '/child/hadith',
        progressValue: 0.1,
        color: AppColors.coralBg,
        accentColor: AppColors.coral,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2C2A).withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _ContentRow(item: items[i]),
              if (i < items.length - 1)
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md),
                  color: AppColors.border,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContentItem {
  const _ContentItem({
    required this.emoji,
    required this.title,
    required this.stat,
    required this.route,
    required this.progressValue,
    required this.color,
    required this.accentColor,
  });

  final String emoji;
  final String title;
  final String stat;
  final String route;
  final double progressValue;
  final Color color;
  final Color accentColor;
}

class _ContentRow extends StatelessWidget {
  const _ContentRow({required this.item});

  final _ContentItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(item.route),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(item.emoji,
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 2),
                  Text(item.stat,
                      style: AppTextStyles.labelSmall
                          .copyWith(color: item.accentColor)),
                  const SizedBox(height: 6),
                  ProgressBar(
                    value: item.progressValue,
                    color: item.accentColor,
                    backgroundColor: item.color,
                    height: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ─── Settings Shortcut ────────────────────────────────────────────────────────

class _SettingsShortcut extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.go('/parent/dashboard'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2C2A).withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.settings_outlined,
                  color: AppColors.textMuted, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ayarlar', style: AppTextStyles.titleMedium),
                  Text('Süre limiti, bildirimler, PIN',
                      style: AppTextStyles.labelSmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
