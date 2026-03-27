import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_hadith.dart';
import '../../../shared/widgets/arabic_text.dart';

class HadithListScreen extends StatefulWidget {
  const HadithListScreen({super.key});

  @override
  State<HadithListScreen> createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  String _selectedCategory = 'all';

  static const _categories = [
    ('all', 'Tümü'),
    ('ahlak', 'Ahlak'),
    ('ibadet', 'İbadet'),
    ('sosyal', 'Sosyal'),
    ('ilim', 'İlim'),
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 'all') return mockHadiths;
    return mockHadiths
        .where((h) => h['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final learned =
        mockHadiths.where((h) => h['isLearned'] == true).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ─── Header ──────────────────────────────────────────────
          _HadithHeader(learned: learned, total: mockHadiths.length),

          const SizedBox(height: AppSpacing.sm),

          // ─── Kategori filtresi ────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: _categories.map((cat) {
                final selected = _selectedCategory == cat.$1;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = cat.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color:
                          selected ? AppColors.coral : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.coral
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat.$2,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: selected
                              ? AppColors.white
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ─── Liste ────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.md,
              ),
              itemCount: _filtered.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) => _HadithCard(
                hadith: _filtered[i],
              ).animate().fadeIn(delay: (i * 50).ms).slideX(begin: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _HadithHeader extends StatelessWidget {
  const _HadithHeader({required this.learned, required this.total});

  final int learned;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.coral,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.coral,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hadis & Sünnet',
                      style: AppTextStyles.headlineLarge
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      '$learned/$total hadis ezberlendi',
                      style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              AppColors.white.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: total > 0 ? learned / total : 0,
                      backgroundColor:
                          AppColors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation(
                          AppColors.white),
                      strokeWidth: 5,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '$learned/$total',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hadis Kartı ──────────────────────────────────────────────────────────────

class _HadithCard extends StatelessWidget {
  const _HadithCard({required this.hadith});

  final Map<String, dynamic> hadith;

  @override
  Widget build(BuildContext context) {
    final isLearned = hadith['isLearned'] as bool;
    final category = hadith['category'] as String;

    return GestureDetector(
      onTap: () => context.go('/child/hadith/${hadith['id']}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2C2A).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ─ Sol ikon ─────────────────────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isLearned ? AppColors.primaryBg : AppColors.coralBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  isLearned
                      ? Icons.check_rounded
                      : Icons.format_quote_rounded,
                  color: isLearned ? AppColors.primary : AppColors.coral,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // ─ İçerik ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hadith['nameTr'] as String,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      if (isLearned)
                        _StatusChip(
                            label: 'Ezberlendi',
                            color: AppColors.primary,
                            bgColor: AppColors.primaryBg)
                      else
                        _CategoryChip(category: category),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ArabicText(
                    hadith['arabic'] as String,
                    fontSize: 15,
                    color: AppColors.textMuted,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hadith['source'] as String,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.coral,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ─── Küçük yardımcı widget'lar ────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final String category;

  static const _labels = {
    'ahlak': 'Ahlak',
    'ibadet': 'İbadet',
    'sosyal': 'Sosyal',
    'ilim': 'İlim',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.coralBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _labels[category] ?? category,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.coral,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
