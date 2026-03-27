import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.xl),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nûr\'u Destekle',
                            style: AppTextStyles.headlineMedium
                                .copyWith(color: AppColors.white),
                          ),
                          Text(
                            'Reklamsız, ücretsiz kalmaya devam etmemize yardım et',
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.white.withValues(alpha: 0.85)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'Uygulama tamamen ücretsiz ve reklamsızdır.',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textMuted),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  Text('Tek Seferlik Destek', style: AppTextStyles.titleLarge)
                      .animate()
                      .fadeIn(delay: 100.ms),

                  const SizedBox(height: AppSpacing.sm),

                  ...[
                    _SupportOption(
                      emoji: '☕',
                      title: 'Bir Çay Ismarla',
                      subtitle: 'Küçük bir destek, büyük bir teşekkür',
                      price: '₺99',
                      delay: 150,
                    ),
                    _SupportOption(
                      emoji: '☕',
                      title: 'Türk Kahvesi Ismarla',
                      subtitle: 'Uzun gecelerde kod yazarken içeriz',
                      price: '₺199',
                      delay: 220,
                    ),
                    _SupportOption(
                      emoji: '💻',
                      title: 'Donanım Desteği',
                      subtitle: 'Sunucu ve geliştirme araçları için',
                      price: '₺729',
                      delay: 290,
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  Text('Aylık Destek', style: AppTextStyles.titleLarge)
                      .animate()
                      .fadeIn(delay: 360.ms),

                  const SizedBox(height: AppSpacing.sm),

                  _MonthlyCard(delay: 400),

                  const SizedBox(height: AppSpacing.xl),

                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('🌟', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Destek olsan da olmasan da Nûr sonsuza dek ücretsiz kalacak. Allah kabul etsin 🤲',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.primaryDark),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportOption extends StatelessWidget {
  const _SupportOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.delay,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final String price;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title seçildi — yakında aktif olacak!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        child: Container(
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
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium),
                    Text(subtitle,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  price,
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: 0.05),
    );
  }
}

class _MonthlyCard extends StatelessWidget {
  const _MonthlyCard({required this.delay});

  final int delay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Aylık destek — yakında aktif olacak!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Text('🌙', style: TextStyle(fontSize: 36)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aylık Destekçi',
                    style:
                        AppTextStyles.titleLarge.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nûr\'un sürekli gelişmesine destek ol\nReklamlara gerek kalmadan büyüyelim',
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '₺49 / ay',
                      style: AppTextStyles.titleMedium
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.05);
  }
}
