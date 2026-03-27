import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import 'nur_button.dart';

class LockedContentSheet extends StatelessWidget {
  const LockedContentSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const LockedContentSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Lock icon
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.rewardBg,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🔒', style: TextStyle(fontSize: 32)),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Bu içerik Pro\'ya özel',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Tüm surelere, dualara ve kıssalara\nsınırsız erişim için Pro\'ya geçin.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Feature list
          ..._features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(f, style: AppTextStyles.bodyMedium),
                  ],
                ),
              )),

          const SizedBox(height: AppSpacing.lg),

          NurButton(
            label: 'Pro\'ya Geç',
            icon: '✨',
            onPressed: () {
              Navigator.pop(context);
              context.push('/paywall');
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Şimdi değil',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMuted),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  static const _features = [
    'Tüm sureler — eksiksiz öğrenme',
    '50\'den fazla günlük dua',
    'Peygamber kıssaları ve sesli anlatım',
    'Ebeveyn raporu ve haftalık analiz',
  ];
}
