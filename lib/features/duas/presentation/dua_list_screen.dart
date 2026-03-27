import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_duas.dart';
import '../../../shared/widgets/arabic_text.dart';

class DuaListScreen extends StatefulWidget {
  const DuaListScreen({super.key});

  @override
  State<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  String _selectedCategory = 'all';

  static const _categories = [
    ('all', 'Tümü'),
    ('daily', 'Günlük'),
    ('morning', 'Sabah'),
    ('sleep', 'Uyku'),
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 'all') return mockDuas;
    return mockDuas
        .where((d) => d['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final learned = mockDuas.where((d) => d['isLearned'] == true).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Header
          _DuaHeader(learned: learned, total: mockDuas.length),

          // Kategori filtresi
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final selected = _selectedCategory == cat.$1;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = cat.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.dua : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              selected ? AppColors.dua : AppColors.border,
                        ),
                      ),
                      child: Text(
                        cat.$2,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: selected
                              ? AppColors.white
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Liste
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.md,
              ),
              itemCount: _filtered.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) => _DuaCard(
                dua: _filtered[i],
              ).animate().fadeIn(delay: (i * 50).ms).slideX(begin: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DuaHeader extends StatelessWidget {
  const _DuaHeader({required this.learned, required this.total});

  final int learned;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dua,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.md),
          decoration: const BoxDecoration(
            color: AppColors.dua,
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
                      'Dualar',
                      style: AppTextStyles.headlineLarge
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      '$learned/$total dua öğrenildi',
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8)),
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
                      value: learned / total,
                      backgroundColor:
                          AppColors.white.withValues(alpha: 0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.white),
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

// ─── Dua Card ─────────────────────────────────────────────────────────────────

class _DuaCard extends StatelessWidget {
  const _DuaCard({required this.dua});

  final Map<String, dynamic> dua;

  @override
  Widget build(BuildContext context) {
    final isLearned = dua['isLearned'] as bool;

    return GestureDetector(
      onTap: () => context.go('/child/duas/${dua['id']}'),
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
            // Öğrenildi göstergesi
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isLearned ? AppColors.primaryBg : AppColors.duaBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                        isLearned
                            ? Icons.check_rounded
                            : Icons.volunteer_activism_outlined,
                        color: isLearned ? AppColors.primary : AppColors.dua,
                        size: 20,
                      ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dua['nameTr'] as String,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (isLearned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Öğrenildi',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  ArabicText(
                    dua['arabic'] as String,
                    fontSize: 16,
                    color: AppColors.textMuted,
                    textAlign: TextAlign.left,
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
