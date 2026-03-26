import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';

enum NurButtonVariant { primary, secondary, outline }

class NurButton extends StatelessWidget {
  const NurButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = NurButtonVariant.primary,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final NurButtonVariant variant;
  final String? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;

    final (bgColor, textColor, border) = switch (variant) {
      NurButtonVariant.primary => (
          disabled ? AppColors.border : AppColors.primary,
          AppColors.white,
          null,
        ),
      NurButtonVariant.secondary => (
          AppColors.primaryBg,
          AppColors.primary,
          null,
        ),
      NurButtonVariant.outline => (
          Colors.transparent,
          AppColors.primary,
          Border.all(color: AppColors.primary, width: 1.5),
        ),
    };

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: border,
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Text(icon!, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: AppTextStyles.titleMedium.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
