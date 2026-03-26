import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({
    super.key,
    required this.icon,
    required this.nameTr,
    required this.earned,
  });

  final String icon;
  final String nameTr;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: earned ? AppColors.rewardBg : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: earned ? AppColors.reward : AppColors.border,
                width: 2,
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: earned ? 1.0 : 0.35,
                child: Text(icon, style: const TextStyle(fontSize: 26)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            nameTr,
            style: AppTextStyles.labelSmall.copyWith(
              color: earned ? AppColors.reward : AppColors.textMuted,
              fontWeight: earned ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
