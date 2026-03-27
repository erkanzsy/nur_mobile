import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_stories.dart';

class StoryListScreen extends StatelessWidget {
  const StoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completed =
        mockStories.where((s) => s['isCompleted'] == true).length;

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
                            'Peygamber Kıssaları',
                            style: AppTextStyles.headlineLarge
                                .copyWith(color: AppColors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completed/${mockStories.length} kıssa tamamlandı',
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.white.withValues(alpha: 0.85)),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: mockStories.isEmpty
                                ? 0
                                : completed / mockStories.length,
                            backgroundColor:
                                AppColors.white.withValues(alpha: 0.2),
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.white),
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          '$completed/${mockStories.length}',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Kıssa grid
          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.85,
              ),
              itemCount: mockStories.length,
              itemBuilder: (context, i) => _StoryCard(
                story: mockStories[i],
              ).animate().fadeIn(delay: (i * 80).ms).scale(
                    begin: const Offset(0.95, 0.95),
                    delay: (i * 80).ms,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Story Card ───────────────────────────────────────────────────────────────

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.story});

  final Map<String, dynamic> story;

  @override
  Widget build(BuildContext context) {
    final isCompleted = story['isCompleted'] as bool;

    return GestureDetector(
      onTap: () {
        // Yakında: context.go('/child/stories/${story['id']}')
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${story['nameTr']} — yakında hazır!'),
            backgroundColor: AppColors.reward,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2C2A).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji illustration area
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primaryBg : AppColors.rewardBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      story['emoji'] as String,
                      style: const TextStyle(fontSize: 52),
                    ),
                  ),
                  if (isCompleted)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: AppColors.white, size: 14),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story['nameTr'] as String,
                    style: AppTextStyles.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    story['description'] as String,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
