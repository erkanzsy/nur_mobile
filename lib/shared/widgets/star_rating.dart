import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.stars,
    this.maxStars = 3,
    this.size = 20,
  });

  final int stars;
  final int maxStars;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxStars,
        (i) => Icon(
          i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < stars ? AppColors.reward : AppColors.border,
          size: size,
        ),
      ),
    );
  }
}
