import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_hareke.dart';
import '../../../shared/widgets/arabic_text.dart';
import '../../../shared/widgets/audio_player_widget.dart';

class HarekeLearnScreen extends StatefulWidget {
  const HarekeLearnScreen({super.key});

  @override
  State<HarekeLearnScreen> createState() => _HarekeLearnScreenState();
}

class _HarekeLearnScreenState extends State<HarekeLearnScreen> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = mockHarekeLetters.length;
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == total - 1;
    final currentLetter = mockHarekeLetters[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ─── Header ──────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => context.go('/child/home'),
                    color: AppColors.textPrimary,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Elif-Ba Öğren', style: AppTextStyles.titleMedium),
                        Text(
                          '${_currentIndex + 1} / $total harf',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  // Harf adı + ilerleme çubuğu
                  SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currentLetter['nameTr'] as String,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (_currentIndex + 1) / total,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.primary),
                            minHeight: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Harf sayfaları ──────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemCount: total,
              itemBuilder: (_, i) =>
                  _LetterPage(letter: mockHarekeLetters[i]),
            ),
          ),

          // ─── Alt navigasyon ──────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
            child: Row(
              children: [
                if (!isFirst) ...[
                  Expanded(
                    child: _NavButton(
                      label: 'Önceki',
                      icon: Icons.arrow_back_rounded,
                      onTap: () => _goToPage(_currentIndex - 1),
                      primary: false,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: _NavButton(
                    label: isLast ? 'Tamamlandı' : 'Sonraki',
                    icon: isLast
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    onTap: isLast
                        ? () {
                            HapticFeedback.heavyImpact();
                            context.go('/child/home');
                          }
                        : () => _goToPage(_currentIndex + 1),
                    primary: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Harf sayfası ─────────────────────────────────────────────────────────────

class _LetterPage extends StatefulWidget {
  const _LetterPage({required this.letter});

  final Map<String, dynamic> letter;

  @override
  State<_LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<_LetterPage> {
  String _selectedHareke = 'fetha';
  Key _letterAnimKey = UniqueKey();

  void _select(String hareke) {
    if (hareke == _selectedHareke) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selectedHareke = hareke;
      _letterAnimKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.letter;
    final combined = letter['${_selectedHareke}Combined'] as String;
    final sound = letter['${_selectedHareke}Sound'] as String;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─── Büyük harf kutusu ─────────────────────────────
          Container(
            key: _letterAnimKey,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl + 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2C2C2A).withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ArabicText(
                  combined,
                  fontSize: 96,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _harekeLabel(_selectedHareke),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1.0, 1.0),
                duration: 240.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 180.ms),

          const SizedBox(height: AppSpacing.lg),

          // ─── Okunuş ────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              key: ValueKey(sound),
              sound,
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              key: ValueKey('${_selectedHareke}_desc'),
              _harekeShortDesc(_selectedHareke),
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ─── Hareke seçici ─────────────────────────────────
          Row(
            children: [
              'fetha',
              'damme',
              'kasra',
              'sukun',
            ].map((h) {
              final isActive = h == _selectedHareke;
              final hCombined = letter['${h}Combined'] as String;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _select(h),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm + 2, horizontal: 2),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ArabicText(
                          hCombined,
                          fontSize: 26,
                          textAlign: TextAlign.center,
                          color: isActive ? AppColors.white : null,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _harekeShortName(h),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.white
                                : AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ─── Ses butonu ────────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: AudioPlayerWidget(
              audioUrl: letter['audioUrl'] as String?,
              label: '$combined dinle',
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ─── Hareke bilgi kartı ────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Container(
              key: ValueKey('${_selectedHareke}_info'),
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primaryLight.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _harekeLabel(_selectedHareke),
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _harekeDetail(_selectedHareke),
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.primaryDark),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms),
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
          border: primary ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!primary) ...[
              Icon(icon, color: AppColors.textMuted, size: 18),
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

// ─── Yardımcı fonksiyonlar ────────────────────────────────────────────────────

String _harekeLabel(String h) {
  switch (h) {
    case 'fetha': return 'Fetha';
    case 'damme': return 'Damme';
    case 'kasra': return 'Kasra';
    case 'sukun': return 'Sükun';
    default:      return '';
  }
}

String _harekeShortName(String h) {
  switch (h) {
    case 'fetha': return 'Fetha';
    case 'damme': return 'Damme';
    case 'kasra': return 'Kasra';
    case 'sukun': return 'Sükun';
    default:      return '';
  }
}

String _harekeShortDesc(String h) {
  switch (h) {
    case 'fetha': return '"e" veya "a" sesi verir';
    case 'damme': return '"u" sesi verir';
    case 'kasra': return '"i" sesi verir';
    case 'sukun': return 'Sessiz harf — harekesiz okunur';
    default:      return '';
  }
}

String _harekeDetail(String h) {
  switch (h) {
    case 'fetha':
      return 'Fetha harfin üstüne konur. Ağzını hafifçe açarak "e" veya "a" sesi çıkar. Kısa, açık bir ses verir.';
    case 'damme':
      return 'Damme harfin üstüne konur. Dudaklarını yuvarlayarak öne doğru uzat ve "u" sesi çıkar. Kısa bir ses verir.';
    case 'kasra':
      return 'Kasra harfin altına konur. Alt dudağını hafifçe indirerek "i" sesi çıkar. Kısa, ince bir ses verir.';
    case 'sukun':
      return 'Sükun harfin üstüne konur. Harf hiç seslendirilmez; sessiz kalır ve önceki harfe bağlanır.';
    default:
      return '';
  }
}
