import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_badges.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final earned = mockBadges.where((b) => b['earned'] == true).toList();
    final locked = mockBadges.where((b) => b['earned'] == false).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.reward,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
                decoration: const BoxDecoration(
                  color: AppColors.reward,
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
                            'Rozetlerim',
                            style: AppTextStyles.headlineLarge
                                .copyWith(color: AppColors.white),
                          ),
                          Text(
                            '${earned.length} kazanıldı • ${locked.length} kilitli',
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.white.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                    // Rozet sayacı
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 6),
                          Text(
                            '${earned.length}/${mockBadges.length}',
                            style: AppTextStyles.titleMedium
                                .copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Liste
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kazanılanlar
                  if (earned.isNotEmpty) ...[
                    Text('Kazandıklarım ✨', style: AppTextStyles.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    _BadgeGrid(badges: earned, isEarned: true),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Kilitliler
                  if (locked.isNotEmpty) ...[
                    Text('Henüz Kazanılmadı',
                        style: AppTextStyles.titleLarge
                            .copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Öğrenmeye devam et ve bu rozetleri kazan!',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _BadgeGrid(badges: locked, isEarned: false),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.badges, required this.isEarned});

  final List<Map<String, dynamic>> badges;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: badges.length,
      itemBuilder: (context, i) {
        final badge = badges[i];
        return _BigBadgeCard(
          icon: badge['icon'] as String,
          nameTr: badge['nameTr'] as String,
          earned: badge['earned'] as bool,
        )
            .animate()
            .fadeIn(delay: (i * 60).ms)
            .scale(
              delay: (i * 60).ms,
              begin: const Offset(0.8, 0.8),
              duration: 400.ms,
              curve: Curves.elasticOut,
            );
      },
    );
  }
}

class _BigBadgeCard extends StatelessWidget {
  const _BigBadgeCard({
    required this.icon,
    required this.nameTr,
    required this.earned,
  });

  final String icon;
  final String nameTr;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: earned ? AppColors.rewardBg : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: earned ? AppColors.reward : AppColors.border,
              width: 2.5,
            ),
            boxShadow: earned
                ? [
                    BoxShadow(
                      color: AppColors.reward.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Opacity(
              opacity: earned ? 1.0 : 0.3,
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          nameTr,
          style: AppTextStyles.labelSmall.copyWith(
            color: earned ? AppColors.reward : AppColors.textMuted,
            fontWeight: earned ? FontWeight.w700 : FontWeight.w400,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
