import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/nur_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _slides = [
    _Slide(
      bgTop: AppColors.primaryDark,
      bgBottom: AppColors.primary,
      illustration: 'نور',
      isArabic: true,
      title: 'Nûr\'a Hoş Geldiniz',
      subtitle: 'Çocuğunuzla Kuran öğrenme\nyolculuğuna başlayın',
      illustrationSize: 96,
    ),
    _Slide(
      bgTop: AppColors.white,
      bgBottom: AppColors.surface,
      illustration: '📖',
      isArabic: false,
      title: 'Eğlenerek Öğren',
      subtitle: 'Sureler, dualar, peygamber kıssaları\nve interaktif quizler',
      illustrationSize: 80,
    ),
    _Slide(
      bgTop: AppColors.primaryBg,
      bgBottom: AppColors.surface,
      illustration: '🌙',
      isArabic: false,
      title: 'Ebeveyn Kontrolü',
      subtitle: 'Günlük süre limiti, ilerleme takibi\nve özelleştirilmiş hedefler',
      illustrationSize: 80,
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/child/home');
    }
  }

  void _skip() => context.go('/child/home');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [slide.bgTop, slide.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip butonu
              Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  opacity: isLast ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: TextButton(
                    onPressed: isLast ? null : _skip,
                    child: Text(
                      'Atla',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: _currentPage == 0
                            ? AppColors.white.withValues(alpha: 0.8)
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),

              // Slides
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) =>
                      _SlideView(slide: _slides[index]),
                ),
              ),

              // Dots + CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    // Page dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? (_currentPage == 0
                                    ? AppColors.white
                                    : AppColors.primary)
                                : (_currentPage == 0
                                    ? AppColors.white.withValues(alpha: 0.35)
                                    : AppColors.border),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // CTA button
                    NurButton(
                      label: isLast ? 'Başla' : 'Sonraki',
                      onPressed: _next,
                      variant: _currentPage == 0
                          ? NurButtonVariant.outline
                          : NurButtonVariant.primary,
                    ),

                    if (!isLast) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: _skip,
                        child: Text(
                          'Hesabım var, giriş yap',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _currentPage == 0
                                ? AppColors.white.withValues(alpha: 0.8)
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
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

// ─── Slide data ──────────────────────────────────────────────────────────────

class _Slide {
  const _Slide({
    required this.bgTop,
    required this.bgBottom,
    required this.illustration,
    required this.isArabic,
    required this.title,
    required this.subtitle,
    required this.illustrationSize,
  });

  final Color bgTop;
  final Color bgBottom;
  final String illustration;
  final bool isArabic;
  final String title;
  final String subtitle;
  final double illustrationSize;
}

// ─── Slide view ──────────────────────────────────────────────────────────────

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  bool get _isDark => slide.bgTop == AppColors.primaryDark;

  @override
  Widget build(BuildContext context) {
    final textColor = _isDark ? AppColors.white : AppColors.textPrimary;
    final subtitleColor =
        _isDark ? AppColors.white.withValues(alpha: 0.8) : AppColors.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: _isDark
                  ? AppColors.white.withValues(alpha: 0.12)
                  : AppColors.white,
              shape: BoxShape.circle,
              boxShadow: _isDark
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Center(
              child: slide.isArabic
                  ? Text(
                      slide.illustration,
                      style: TextStyle(
                        fontSize: slide.illustrationSize,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.8,
                      ),
                      textDirection: TextDirection.rtl,
                    )
                  : Text(
                      slide.illustration,
                      style: TextStyle(fontSize: slide.illustrationSize),
                    ),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.85, 0.85), duration: 500.ms),

          const SizedBox(height: AppSpacing.xl),

          Text(
            slide.title,
            style: AppTextStyles.headlineLarge.copyWith(color: textColor),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 400.ms)
              .slideY(begin: 0.2, duration: 400.ms),

          const SizedBox(height: AppSpacing.sm),

          Text(
            slide.subtitle,
            style: AppTextStyles.bodyLarge.copyWith(color: subtitleColor),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 250.ms, duration: 400.ms)
              .slideY(begin: 0.2, duration: 400.ms),
        ],
      ),
    );
  }
}
