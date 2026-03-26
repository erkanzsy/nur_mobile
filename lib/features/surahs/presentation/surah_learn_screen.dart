import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_surahs.dart';
import '../../../shared/widgets/arabic_text.dart';
import '../../../shared/widgets/audio_player_widget.dart';

class SurahLearnScreen extends StatefulWidget {
  const SurahLearnScreen({super.key, required this.surahId});

  final String surahId;

  @override
  State<SurahLearnScreen> createState() => _SurahLearnScreenState();
}

class _SurahLearnScreenState extends State<SurahLearnScreen> {
  int _currentIndex = 0;
  final _pageController = PageController();

  late final Map<String, dynamic> _surah;
  late final List<Map<String, dynamic>> _ayahs;

  @override
  void initState() {
    super.initState();
    _surah = mockSurahs.firstWhere(
      (s) => s['id'] == widget.surahId,
      orElse: () => mockSurahs.first,
    );
    _ayahs = (_surah['ayahs'] as List).cast<Map<String, dynamic>>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ayahs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(_surah['nameTr'] as String)),
        body: const Center(child: Text('İçerik henüz eklenmedi.')),
      );
    }

    final currentAyah = _ayahs[_currentIndex];
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _ayahs.length - 1;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ─── Header ──────────────────────────────────────────────
          _LearnHeader(
            surah: _surah,
            currentIndex: _currentIndex,
            total: _ayahs.length,
          ),

          // ─── Ayet içeriği ────────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemCount: _ayahs.length,
              itemBuilder: (_, i) => _AyahPage(ayah: _ayahs[i]),
            ),
          ),

          // ─── Alt kontroller ──────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Ses oynatıcı
                AudioPlayerWidget(
                  audioUrl: currentAyah['audioUrl'] as String?,
                  label: 'Dinle',
                ),

                const SizedBox(height: AppSpacing.md),

                // Önceki / Sonraki
                Row(
                  children: [
                    if (!isFirst)
                      Expanded(
                        child: _NavButton(
                          label: 'Önceki',
                          icon: Icons.arrow_back_rounded,
                          onTap: () => _goToPage(_currentIndex - 1),
                          primary: false,
                        ),
                      ),
                    if (!isFirst) const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: isFirst ? 1 : 1,
                      child: _NavButton(
                        label: isLast ? 'Tamamlandı' : 'Sonraki',
                        icon: isLast
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        onTap: isLast
                            ? () => context.go('/child/surahs')
                            : () => _goToPage(_currentIndex + 1),
                        primary: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),

                // Progress dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _ayahs.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentIndex == i ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == i
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),

          // ─── Quiz banner ─────────────────────────────────────────
          GestureDetector(
            onTap: () => context.go('/child/quiz/${widget.surahId}'),
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
                  const Text('⭐', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Hazır hissediyorsan Quiz\'e geç!',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.quiz),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.arrow_forward_rounded,
                      color: AppColors.quiz, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Learn Header ─────────────────────────────────────────────────────────────

class _LearnHeader extends StatelessWidget {
  const _LearnHeader({
    required this.surah,
    required this.currentIndex,
    required this.total,
  });

  final Map<String, dynamic> surah;
  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm, AppSpacing.sm, AppSpacing.md, 0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.go('/child/surahs'),
              color: AppColors.textPrimary,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    surah['nameTr'] as String,
                    style: AppTextStyles.titleMedium,
                  ),
                  Text(
                    '${currentIndex + 1}/$total Ayet',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            ArabicText(
              surah['nameAr'] as String,
              fontSize: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

// ─── Ayet sayfası ─────────────────────────────────────────────────────────────

class _AyahPage extends StatelessWidget {
  const _AyahPage({required this.ayah});

  final Map<String, dynamic> ayah;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Ayet numarası
          Container(
            width: 36,
            height: 36,
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
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(height: AppSpacing.md),

          // Arapça metin kutusu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: ArabicText(
              ayah['arabic'] as String,
              fontSize: 30,
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.1),

          const SizedBox(height: AppSpacing.lg),

          // Transliterasyon
          Text(
            ayah['transliteration'] as String,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: AppSpacing.md),

          // Türkçe anlam
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2C2C2A).withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '"${ayah['turkish']}"',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

// ─── Nav button ───────────────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.primary,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm + 4,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: primary
              ? null
              : Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!primary) ...[
              Icon(icon,
                  color: AppColors.textMuted, size: 18),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: primary ? AppColors.white : AppColors.textMuted,
              ),
            ),
            if (primary) ...[
              const SizedBox(width: 6),
              Icon(icon, color: AppColors.white, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
