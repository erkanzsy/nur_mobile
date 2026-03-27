import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/name_provider.dart';
import '../../../core/services/prefs_service.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _step = 0;
  ProfileType? _selectedProfile;

  void _onWelcomeNext() => setState(() => _step = 1);

  void _onProfileSelect(ProfileType type) {
    ref.read(profileProvider.notifier).state = type;
    setState(() {
      _selectedProfile = type;
      _step = 2;
    });
  }

  void _onNameDone(String name) {
    final trimmed = name.trim();
    final profile = _selectedProfile ?? ProfileType.child;
    ref.read(nameProvider.notifier).state = trimmed;
    ref.read(profileProvider.notifier).state = profile;
    PrefsService.completeOnboarding(
      name: trimmed,
      profileType: profile == ProfileType.child ? 'child' : 'adult',
    );
    context.go('/child/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 380),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: switch (_step) {
          0 => _WelcomePage(key: const ValueKey('welcome'), onNext: _onWelcomeNext),
          1 => _ProfilePage(key: const ValueKey('profile'), onSelect: _onProfileSelect),
          _ => _NamePage(
              key: const ValueKey('name'),
              profileType: _selectedProfile ?? ProfileType.child,
              onDone: _onNameDone,
            ),
        },
      ),
    );
  }
}

// ─── Sayfa 1: Hoş Geldin ──────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'نور',
                    style: TextStyle(
                      fontSize: 64,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

              const SizedBox(height: AppSpacing.xl),

              Text(
                'Nûr\'a Hoş Geldiniz',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.2, duration: 400.ms),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Kuran öğrenme yolculuğuna\nhep birlikte başlayalım',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 400.ms)
                  .slideY(begin: 0.2, duration: 400.ms),

              const SizedBox(height: AppSpacing.xl),

              ...[
                ('📖', 'Sureler, dualar, peygamber kıssaları'),
                ('🎯', 'Hareke öğrenimi ve interaktif quizler'),
                ('🤲', 'Hadis ve sünnet ezberi'),
                ('✅', 'Tamamen ücretsiz, internetsiz çalışır'),
              ]
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text(e.value.$1,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            e.value.$2,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(
                          delay: Duration(milliseconds: 450 + e.key * 80),
                          duration: 350.ms,
                        ),
                  ),

              const Spacer(),

              GestureDetector(
                onTap: onNext,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Başla',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.primaryDark),
                    textAlign: TextAlign.center,
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sayfa 2: Profil Seçimi ───────────────────────────────────────────────────

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({super.key, required this.onSelect});

  final void Function(ProfileType) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),

              Text(
                'Kim kullanacak?',
                style: AppTextStyles.headlineLarge,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'İçerik buna göre sunulacak.\nAyarlardan istediğinde değiştirebilirsin.',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textMuted),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.xl),

              _ProfileCard(
                emoji: '⭐',
                title: 'Çocuk Modu',
                subtitle:
                    '4–12 yaş · Oyunlaştırılmış öğrenme\nStreak, rozetler ve günlük hedefler',
                bgColor: AppColors.primaryBg,
                borderColor: AppColors.primary,
                onTap: () => onSelect(ProfileType.child),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

              const SizedBox(height: AppSpacing.md),

              _ProfileCard(
                emoji: '📖',
                title: 'Yetişkin Modu',
                subtitle:
                    'Sureler, dualar, hadisler\nKendi hızında, kendi kendine öğren',
                bgColor: AppColors.rewardBg,
                borderColor: AppColors.reward,
                onTap: () => onSelect(ProfileType.adult),
              ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

              const Spacer(),

              Center(
                child: Text(
                  'Tüm içerikler ücretsiz · Çevrimdışı çalışır',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(delay: 450.ms),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sayfa 3: İsim Girişi ─────────────────────────────────────────────────────

class _NamePage extends StatefulWidget {
  const _NamePage({
    super.key,
    required this.profileType,
    required this.onDone,
  });

  final ProfileType profileType;
  final void Function(String) onDone;

  @override
  State<_NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<_NamePage> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.trim().isNotEmpty);
    });
    // Klavyeyi otomatik aç
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focus);
    });
  }

  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isChild = widget.profileType == ProfileType.child;
    final question = isChild ? 'Adın ne?' : 'Adınız nedir?';
    final hint = isChild ? 'Kerem, Erkan, Ahmet...' : 'Kerem, Erkan, Ahmet...';
    final btnLabel = isChild ? 'Hadi başlayalım!' : 'Başlayalım';

    return Container(
      color: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // İkon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isChild ? AppColors.primaryBg : AppColors.rewardBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    isChild ? '👋' : '✋',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).scale(
                    begin: const Offset(0.8, 0.8), duration: 400.ms),

              const SizedBox(height: AppSpacing.lg),

              Text(
                question,
                style: AppTextStyles.headlineLarge,
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(begin: 0.15),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Sana nasıl hitap edelim?',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textMuted),
              ).animate().fadeIn(delay: 180.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.xl),

              // İsim text field
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasText ? AppColors.primary : AppColors.border,
                    width: _hasText ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color(0xFF2C2C2A).withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  style: AppTextStyles.titleLarge,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onSubmitted: _hasText
                      ? (_) => widget.onDone(_controller.text)
                      : null,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.border),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    suffixIcon: _hasText
                        ? const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary)
                        : null,
                  ),
                ),
              ).animate().fadeIn(delay: 260.ms).slideY(begin: 0.1),

              const Spacer(),

              // Devam butonu
              AnimatedOpacity(
                opacity: _hasText ? 1.0 : 0.35,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: _hasText
                      ? () => widget.onDone(_controller.text)
                      : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      btnLabel,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms),

              const SizedBox(height: AppSpacing.sm),

              // Atla
              Center(
                child: TextButton(
                  onPressed: () => widget.onDone(''),
                  child: Text(
                    'Şimdi değil',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textMuted),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Profile Card ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: borderColor.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child:
                    Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.arrow_forward_ios_rounded,
                color: borderColor, size: 18),
          ],
        ),
      ),
    );
  }
}
