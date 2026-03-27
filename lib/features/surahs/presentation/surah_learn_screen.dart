import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_surahs.dart';
import '../../../shared/widgets/arabic_text.dart';
import '../../../shared/widgets/audio_player_widget.dart';

class SurahLearnScreen extends StatelessWidget {
  const SurahLearnScreen({super.key, required this.surahId});

  final String surahId;

  @override
  Widget build(BuildContext context) {
    final surah = mockSurahs.firstWhere(
      (s) => s['id'] == surahId,
      orElse: () => mockSurahs.first,
    );
    final ayahs =
        (surah['ayahs'] as List).cast<Map<String, dynamic>>();

    if (ayahs.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text(surah['nameTr'] as String),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        body: const Center(
          child: Text('İçerik henüz eklenmedi.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ─── Header ────────────────────────────────────────────────
          _LearnHeader(surah: surah, ayahCount: ayahs.length),

          // ─── Tüm ayetler — scroll edilebilir ───────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
              ),
              itemCount: ayahs.length,
              itemBuilder: (context, i) => _AyahCard(
                ayah: ayahs[i],
                isLast: i == ayahs.length - 1,
              ).animate().fadeIn(
                    delay: Duration(milliseconds: i * 60),
                    duration: 400.ms,
                  ),
            ),
          ),

          // ─── Alt bar: ses + quiz ────────────────────────────────────
          _BottomBar(surahId: surahId),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _LearnHeader extends StatelessWidget {
  const _LearnHeader({required this.surah, required this.ayahCount});

  final Map<String, dynamic> surah;
  final int ayahCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs, AppSpacing.xs, AppSpacing.md, AppSpacing.md),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.white),
                onPressed: () => context.go('/child/surahs'),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      surah['nameTr'] as String,
                      style: AppTextStyles.titleLarge
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      '$ayahCount Ayet',
                      style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              ArabicText(
                surah['nameAr'] as String,
                fontSize: 22,
                color: AppColors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ayet Kartı ───────────────────────────────────────────────────────────────

class _AyahCard extends StatelessWidget {
  const _AyahCard({required this.ayah, required this.isLast});

  final Map<String, dynamic> ayah;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2C2A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayet numarası — üst sağ
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${ayah['number']}',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Arapça metin
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
            child: ArabicText(
              ayah['arabic'] as String,
              fontSize: 28,
              textAlign: TextAlign.center,
            ),
          ),

          // Ayraç
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            color: AppColors.border,
          ),

          // Transliterasyon
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
            child: Text(
              ayah['transliteration'] as String,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Türkçe anlam
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            child: Text(
              ayah['turkish'] as String,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Alt Bar ──────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.surahId});

  final String surahId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ses oynatıcı
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
          child: const AudioPlayerWidget(audioUrl: null, label: 'Tüm Sureyi Dinle'),
        ),

        // Quiz banner
        GestureDetector(
          onTap: () => context.go('/child/quiz/$surahId'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            color: AppColors.quizBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 16)),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Hazır hissediyorsan Quiz\'e geç!',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.quiz),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.quiz, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
