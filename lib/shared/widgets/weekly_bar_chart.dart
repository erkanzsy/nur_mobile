import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.data,
    this.maxHeight = 80,
    this.todayIndex = 6,
  });

  final List<int> data; // minutes per day, 7 items
  final double maxHeight;
  final int todayIndex;

  static const _days = ['Pts', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  Widget build(BuildContext context) {
    final maxVal = data.fold(0, (a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(data.length, (i) {
        final ratio = maxVal == 0 ? 0.0 : data[i] / maxVal;
        final barH = (ratio * maxHeight).clamp(4.0, maxHeight);
        final isToday = i == todayIndex;
        final color = isToday ? AppColors.primary : AppColors.primaryLight;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dakika etiketi (sadece today ve max)
                if (isToday)
                  Text(
                    '${data[i]}dk',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                if (!isToday) const SizedBox(height: 14),

                const SizedBox(height: 4),

                // Bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: barH,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 6),

                // Gün etiketi
                Text(
                  _days[i],
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isToday ? AppColors.primary : AppColors.textMuted,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
