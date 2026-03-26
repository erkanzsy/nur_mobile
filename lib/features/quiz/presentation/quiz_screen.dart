import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_quiz.dart';
import '../../../mocks/mock_surahs.dart';
import '../../../shared/widgets/arabic_text.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.surahId});

  final String surahId;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;
  bool _finished = false;

  late final List<Map<String, dynamic>> _questions;
  late final String _surahName;

  @override
  void initState() {
    super.initState();
    final surahQuiz = mockQuiz[widget.surahId];
    _questions = surahQuiz != null
        ? surahQuiz.cast<Map<String, dynamic>>()
        : (mockQuiz.values.first as List).cast<Map<String, dynamic>>();

    final surah = mockSurahs.firstWhere(
      (s) => s['id'] == widget.surahId,
      orElse: () => mockSurahs.first,
    );
    _surahName = surah['nameTr'] as String;
  }

  Map<String, dynamic> get _current => _questions[_questionIndex];

  int get _stars {
    final ratio = _correctCount / _questions.length;
    if (ratio == 1.0) return 3;
    if (ratio >= 0.67) return 2;
    if (ratio > 0) return 1;
    return 0;
  }

  void _onOptionTap(int index) {
    if (_answered) return;
    final correct = _current['correctIndex'] as int;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == correct) {
        _correctCount++;
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.vibrate();
      }
    });
  }

  void _next() {
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _ResultView(stars: _stars, correct: _correctCount, total: _questions.length, surahId: widget.surahId);

    final correct = _current['correctIndex'] as int;
    final arabic = _current['arabic'] as String?;
    final options = (_current['options'] as List).cast<String>();

    return Scaffold(
      backgroundColor: AppColors.quizBg,
      body: Column(
        children: [
          // ─── Header ──────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: AppColors.quiz,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.white),
                          onPressed: () => context.go('/child/surahs/${widget.surahId}'),
                        ),
                        Expanded(
                          child: Text(
                            '$_surahName Quiz',
                            style: AppTextStyles.titleLarge
                                .copyWith(color: AppColors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          '${_questionIndex + 1}/${_questions.length}',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_questionIndex + 1) / _questions.length,
                        backgroundColor:
                            AppColors.white.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation(AppColors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Soru alanı ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.sm),

                  // Arabic ayet (varsa)
                  if (arabic != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ArabicText(
                        arabic,
                        fontSize: 28,
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fadeIn(duration: 300.ms),

                  if (arabic != null) const SizedBox(height: AppSpacing.md),

                  // Soru metni
                  Text(
                    _current['question'] as String,
                    style: AppTextStyles.titleLarge,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Seçenekler
                  ...List.generate(options.length, (i) {
                    final isSelected = _selectedOption == i;
                    final isCorrect = i == correct;

                    Color bg = AppColors.white;
                    Color border = AppColors.border;
                    Color textColor = AppColors.textPrimary;

                    if (_answered) {
                      if (isCorrect) {
                        bg = AppColors.primaryBg;
                        border = AppColors.primary;
                        textColor = AppColors.primary;
                      } else if (isSelected) {
                        bg = AppColors.coralBg;
                        border = AppColors.coral;
                        textColor = AppColors.coral;
                      }
                    } else if (isSelected) {
                      bg = AppColors.quizBg;
                      border = AppColors.quiz;
                    }

                    Widget option = GestureDetector(
                      onTap: () => _onOptionTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: border, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: border.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + i), // A B C D
                                  style: AppTextStyles.labelLarge
                                      .copyWith(color: textColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                options[i],
                                style: AppTextStyles.bodyLarge
                                    .copyWith(color: textColor),
                              ),
                            ),
                            if (_answered && isCorrect)
                              const Icon(Icons.check_circle_rounded,
                                  color: AppColors.primary, size: 20),
                            if (_answered && isSelected && !isCorrect)
                              const Icon(Icons.cancel_rounded,
                                  color: AppColors.coral, size: 20),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: (i * 80 + 200).ms).slideX(begin: 0.05);

                    // Yanlış seçilince salla
                    if (_answered && isSelected && !isCorrect) {
                      option = option.animate().shake(
                            hz: 4,
                            duration: 400.ms,
                            curve: Curves.easeInOut,
                          );
                    }

                    return option;
                  }),

                  const SizedBox(height: AppSpacing.md),

                  // Sonraki butonu
                  AnimatedOpacity(
                    opacity: _answered ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: _answered ? _next : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.quiz,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _questionIndex == _questions.length - 1
                              ? 'Sonucu Gör'
                              : 'Sonraki Soru',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sonuç ekranı ─────────────────────────────────────────────────────────────

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.stars,
    required this.correct,
    required this.total,
    required this.surahId,
  });

  final int stars;
  final int correct;
  final int total;
  final String surahId;

  @override
  Widget build(BuildContext context) {
    final messages = ['Devam et!', 'İyi iş!', 'Harika!', 'Mükemmel! 🎉'];
    final message = messages[stars];

    return Scaffold(
      backgroundColor: AppColors.quizBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Yıldızlar (animasyonlu)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final earned = i < stars;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        earned ? '⭐' : '☆',
                        style: TextStyle(
                          fontSize: earned ? 52 : 40,
                          color: earned ? null : AppColors.border,
                        ),
                      )
                          .animate()
                          .scale(
                            delay: Duration(milliseconds: i * 200),
                            begin: const Offset(0.3, 0.3),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          )
                          .fadeIn(delay: Duration(milliseconds: i * 200)),
                    );
                  }),
                ),

                const SizedBox(height: AppSpacing.lg),

                Text(
                  message,
                  style: AppTextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  '$correct/$total doğru cevap',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: AppColors.textMuted),
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: AppSpacing.xxl),

                GestureDetector(
                  onTap: () => context.go('/child/home'),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.quiz,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Ana Sayfaya Dön',
                      style: AppTextStyles.titleMedium
                          .copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ).animate().fadeIn(delay: 900.ms),

                const SizedBox(height: AppSpacing.sm),

                TextButton(
                  onPressed: () =>
                      context.go('/child/surahs/$surahId'),
                  child: Text(
                    'Tekrar Dene',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.quiz),
                  ),
                ).animate().fadeIn(delay: 1000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
