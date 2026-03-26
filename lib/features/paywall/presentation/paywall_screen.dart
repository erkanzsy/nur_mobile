import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/nur_button.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Kapat
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.white),
                  onPressed: () => context.pop(),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: Column(
                    children: [
                      // Logo
                      const Text('✨',
                          style: TextStyle(fontSize: 72))
                          .animate()
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: AppSpacing.md),

                      Text(
                        'Nûr Pro',
                        style: AppTextStyles.displayLarge
                            .copyWith(color: AppColors.white),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: AppSpacing.sm),

                      Text(
                        'Çocuğunuzun Kuran yolculuğunu\ntam potansiyeline taşıyın',
                        style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.white.withValues(alpha: 0.85)),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: AppSpacing.xl),

                      // Özellikler
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: _features
                              .asMap()
                              .entries
                              .map(
                                (e) => _FeatureRow(
                                  icon: e.value.$1,
                                  text: e.value.$2,
                                  delay: e.key * 80,
                                ),
                              )
                              .toList(),
                        ),
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: AppSpacing.xl),

                      // Fiyat
                      Column(
                        children: [
                          Text(
                            '₺29,99',
                            style: AppTextStyles.displayLarge
                                .copyWith(color: AppColors.white),
                          ),
                          Text(
                            'aylık • İstediğin zaman iptal et',
                            style: AppTextStyles.bodyMedium.copyWith(
                                color:
                                    AppColors.white.withValues(alpha: 0.7)),
                          ),
                        ],
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: AppSpacing.lg),

                      // CTA
                      NurButton(
                        label: 'Pro\'ya Geç',
                        icon: '✨',
                        onPressed: () {},
                        variant: NurButtonVariant.secondary,
                      ).animate().fadeIn(delay: 700.ms),

                      const SizedBox(height: AppSpacing.sm),

                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Ücretsiz devam et',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color:
                                  AppColors.white.withValues(alpha: 0.7)),
                        ),
                      ).animate().fadeIn(delay: 800.ms),

                      const SizedBox(height: AppSpacing.md),

                      Text(
                        'Satın alma App Store üzerinden gerçekleşir.\nFaturalandırma önizleme için devre dışı.',
                        style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.5),
                            fontSize: 10),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 900.ms),

                      const SizedBox(height: AppSpacing.lg),
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

  static const _features = [
    ('📖', 'Tüm sureler — eksiksiz sesli öğrenme'),
    ('🤲', '50\'den fazla günlük dua'),
    ('📚', 'Peygamber kıssaları ve sesli anlatım'),
    ('📊', 'Haftalık ilerleme raporu'),
    ('⏱', 'Kişiselleştirilebilir günlük hedef'),
    ('🔔', 'Günlük hatırlatıcı bildirimi'),
  ];
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.text,
    required this.delay,
  });

  final String icon;
  final String text;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.md),
          Text(
            text,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.white),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 400 + delay)).slideX(begin: 0.1);
  }
}
