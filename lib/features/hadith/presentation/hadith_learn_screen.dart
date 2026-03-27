import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_hadith.dart';
import '../../../shared/widgets/arabic_text.dart';
import '../../../shared/widgets/audio_player_widget.dart';
import '../../../shared/widgets/nur_button.dart';

class HadithLearnScreen extends StatefulWidget {
  const HadithLearnScreen({super.key, required this.hadithId});

  final String hadithId;

  @override
  State<HadithLearnScreen> createState() => _HadithLearnScreenState();
}

class _HadithLearnScreenState extends State<HadithLearnScreen> {
  bool _learned = false;
  late final Map<String, dynamic> _hadith;

  @override
  void initState() {
    super.initState();
    _hadith = mockHadiths.firstWhere(
      (h) => h['id'] == widget.hadithId,
      orElse: () => mockHadiths.first,
    );
    _learned = _hadith['isLearned'] as bool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ─── Header ──────────────────────────────────────────────
          Container(
            color: AppColors.coral,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.md),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.white),
                      onPressed: () => context.go('/child/hadith'),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _hadith['nameTr'] as String,
                            style: AppTextStyles.titleLarge
                                .copyWith(color: AppColors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            _hadith['source'] as String,
                            style: AppTextStyles.labelSmall.copyWith(
                              color:
                                  AppColors.white.withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // ─── İçerik ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.sm),

                  // ─ Arapça metin ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.coral.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ArabicText(
                      _hadith['arabic'] as String,
                      fontSize: 30,
                      textAlign: TextAlign.center,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1),

                  const SizedBox(height: AppSpacing.lg),

                  // ─ Ses butonu ─────────────────────────────────
                  AudioPlayerWidget(
                    audioUrl: _hadith['audioUrl'] as String?,
                    label: 'Hadisi Dinle',
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // ─ Okunuş ─────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.coralBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Okunuş',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.coral),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _hadith['transliteration'] as String,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.coral,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 250.ms),

                  const SizedBox(height: AppSpacing.md),

                  // ─ Türkçe anlam ───────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Anlamı',
                            style: AppTextStyles.labelLarge),
                        const SizedBox(height: 6),
                        Text(
                          '"${_hadith['turkish']}"',
                          style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 350.ms),

                  const SizedBox(height: AppSpacing.md),

                  // ─ Çocuk açıklaması ───────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.rewardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.reward.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('💡',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Senin için',
                              style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.reward),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _hadith['childExplanation'] as String,
                          style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 450.ms),

                  const SizedBox(height: AppSpacing.xl),

                  // ─ Ezberledim butonu ──────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _learned
                        ? _LearnedBanner(key: const ValueKey('learned'))
                        : NurButton(
                            key: const ValueKey('not-learned'),
                            label: 'Ezberledim! ✅',
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              setState(() => _learned = true);
                            },
                          ),
                  ).animate().fadeIn(delay: 550.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // ─ Sonraki hadis butonu ───────────────────────
                  _NextHadithButton(currentId: widget.hadithId),

                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ezberlendi afişi ─────────────────────────────────────────────────────────

class _LearnedBanner extends StatelessWidget {
  const _LearnedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.primary, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Bu hadisi ezberledin! ✨',
            style: AppTextStyles.titleMedium
                .copyWith(color: AppColors.primary),
          ),
        ],
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.85, 0.85),
          duration: 400.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 250.ms);
  }
}

// ─── Sonraki hadis butonu ─────────────────────────────────────────────────────

class _NextHadithButton extends StatelessWidget {
  const _NextHadithButton({required this.currentId});

  final String currentId;

  @override
  Widget build(BuildContext context) {
    final currentIdx =
        mockHadiths.indexWhere((h) => h['id'] == currentId);
    final hasNext = currentIdx >= 0 &&
        currentIdx < mockHadiths.length - 1 &&
        mockHadiths[currentIdx + 1]['isUnlocked'] == true;

    if (!hasNext) return const SizedBox.shrink();

    final next = mockHadiths[currentIdx + 1];
    return GestureDetector(
      onTap: () => context.go('/child/hadith/${next['id']}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sonraki Hadis',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.coral),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    next['nameTr'] as String,
                    style: AppTextStyles.titleMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded,
                color: AppColors.coral),
          ],
        ),
      ),
    );
  }
}
