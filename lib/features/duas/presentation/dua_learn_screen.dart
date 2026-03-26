import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_duas.dart';
import '../../../shared/widgets/arabic_text.dart';
import '../../../shared/widgets/audio_player_widget.dart';
import '../../../shared/widgets/nur_button.dart';

class DuaLearnScreen extends StatefulWidget {
  const DuaLearnScreen({super.key, required this.duaId});

  final String duaId;

  @override
  State<DuaLearnScreen> createState() => _DuaLearnScreenState();
}

class _DuaLearnScreenState extends State<DuaLearnScreen> {
  bool _learned = false;

  late final Map<String, dynamic> _dua;

  @override
  void initState() {
    super.initState();
    _dua = mockDuas.firstWhere(
      (d) => d['id'] == widget.duaId,
      orElse: () => mockDuas.first,
    );
    _learned = _dua['isLearned'] as bool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.dua,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.white),
                      onPressed: () => context.go('/child/duas'),
                    ),
                    Expanded(
                      child: Text(
                        _dua['nameTr'] as String,
                        style: AppTextStyles.titleLarge
                            .copyWith(color: AppColors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // İçerik
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.sm),

                  // Arapça metin
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dua.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ArabicText(
                      _dua['arabic'] as String,
                      fontSize: 32,
                      textAlign: TextAlign.center,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1),

                  const SizedBox(height: AppSpacing.lg),

                  // Ses oynatıcı
                  AudioPlayerWidget(
                    audioUrl: null,
                    label: 'Duayı Dinle',
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Transliterasyon
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.duaBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Okunuş',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.dua),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _dua['transliteration'] as String,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.dua,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: AppSpacing.md),

                  // Türkçe anlam
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anlamı',
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '"${_dua['turkish']}"',
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: AppSpacing.xl),

                  // Öğrendim butonu
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _learned
                        ? Container(
                            key: const ValueKey('learned'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: AppColors.primary),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Bu duayı öğrendin! ✨',
                                  style: AppTextStyles.titleMedium
                                      .copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          )
                        : NurButton(
                            key: const ValueKey('not-learned'),
                            label: 'Öğrendim! ✅',
                            onPressed: () =>
                                setState(() => _learned = true),
                          ),
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
