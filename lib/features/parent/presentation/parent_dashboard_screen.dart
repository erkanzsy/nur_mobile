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
import '../../../mocks/mock_parent.dart';
import '../../../mocks/mock_progress.dart';
import '../../../shared/widgets/weekly_bar_chart.dart';

class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() =>
      _ParentDashboardScreenState();
}

class _ParentDashboardScreenState
    extends ConsumerState<ParentDashboardScreen> {
  bool _notifEnabled = true;
  int _dailyLimit = 30;

  @override
  void initState() {
    super.initState();
    final settings = mockParent['settings'] as Map<String, dynamic>;
    _notifEnabled = settings['notificationsEnabled'] as bool;
    _dailyLimit = settings['dailyLimitMinutes'] as int;
  }

  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(nameProvider);
    final thisWeek = mockParent['thisWeek'] as Map<String, dynamic>;
    final dailyMinutes =
        (thisWeek['dailyMinutes'] as List).cast<int>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Koyu header ────────────────────────────────────────
            _ParentHeader(
              userName: userName,
              onClose: () => context.go('/child/home'),
            ),

            // ─── Profil kartı ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _ProfileSummaryCard(
                userName: userName,
                thisWeek: thisWeek,
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

            // ─── 4'lü istatistik ────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _StatsGrid(
                progress: mockProgress,
                thisWeek: thisWeek,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: AppSpacing.lg),

            // ─── Haftalık chart ─────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bu Hafta', style: AppTextStyles.titleLarge),
                      Text(
                        '${thisWeek['totalMinutes']} dk toplam',
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 130,
                    child: WeeklyBarChart(
                      data: dailyMinutes,
                      todayIndex: 6,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: AppSpacing.lg),

            // ─── Ayarlar ────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('Ayarlar', style: AppTextStyles.titleLarge),
            ),
            const SizedBox(height: AppSpacing.sm),

            _SettingsCard(
              child: Builder(builder: (context) {
                final profileType = ref.watch(profileProvider);
                final isChild = profileType == ProfileType.child;
                return Column(
                  children: [
                    // Profil modu
                    _SettingRow(
                      icon: Icons.person_outline_rounded,
                      title: 'Kullanım Modu',
                      subtitle: isChild ? 'Çocuk Modu' : 'Yetişkin Modu',
                      trailing: GestureDetector(
                        onTap: () {
                          final next = isChild
                              ? ProfileType.adult
                              : ProfileType.child;
                          ref.read(profileProvider.notifier).state = next;
                          PrefsService.completeOnboarding(
                            name: ref.read(nameProvider),
                            profileType:
                                next == ProfileType.child ? 'child' : 'adult',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isChild
                                ? AppColors.primaryBg
                                : AppColors.rewardBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isChild ? '⭐ Çocuk' : '📖 Yetişkin',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isChild
                                  ? AppColors.primary
                                  : AppColors.reward,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _Divider(),
                    // Günlük süre limiti
                    _SettingRow(
                      icon: Icons.timer_outlined,
                      title: 'Günlük Süre Limiti',
                      subtitle: '$_dailyLimit dakika',
                      trailing: _LimitControl(
                        value: _dailyLimit,
                        onChanged: (v) => setState(() => _dailyLimit = v),
                      ),
                    ),
                    _Divider(),
                    // Bildirimler
                    _SettingRow(
                      icon: Icons.notifications_outlined,
                      title: 'Hatırlatıcı Bildirimi',
                      subtitle: 'Her gün saat 18:00',
                      trailing: Switch.adaptive(
                        value: _notifEnabled,
                        onChanged: (v) =>
                            setState(() => _notifEnabled = v),
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primaryLight,
                      ),
                    ),
                    _Divider(),
                    // PIN
                    _SettingRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Ebeveyn PIN\'i',
                      subtitle: 'Kapalı',
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                      onTap: () {},
                    ),
                    _Divider(),
                    // Dil
                    _SettingRow(
                      icon: Icons.language_outlined,
                      title: 'Dil',
                      subtitle: 'Türkçe',
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                      onTap: () {},
                    ),
                    _Divider(),
                    // Destekle
                    _SettingRow(
                      icon: Icons.favorite_outline_rounded,
                      title: 'Nûr\'u Destekle',
                      subtitle: 'Reklamsız kalmamıza yardım et',
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                      onTap: () => context.push('/support'),
                    ),
                  ],
                );
              }),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ─── Parent Header ───────────────────────────────────────────────────────────

class _ParentHeader extends StatelessWidget {
  const _ParentHeader({required this.userName, required this.onClose});

  final String userName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final subtitle = userName.isNotEmpty
        ? '$userName\'in ilerleme ve ayarları'
        : 'İlerleme ve ayarlar';

    return Container(
      color: AppColors.parent,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.parent,
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
                      'Ayarlar',
                      style: AppTextStyles.headlineMedium
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.white),
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Profile Summary Card ─────────────────────────────────────────────────────

class _ProfileSummaryCard extends ConsumerWidget {
  const _ProfileSummaryCard({
    required this.userName,
    required this.thisWeek,
  });

  final String userName;
  final Map<String, dynamic> thisWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileType = ref.watch(profileProvider);
    final isChild = profileType == ProfileType.child;
    final displayName =
        userName.isNotEmpty ? userName : (isChild ? 'Anonim' : 'Kullanıcı');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                isChild ? '⭐' : '📖',
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.titleLarge
                      .copyWith(color: AppColors.white),
                ),
                Text(
                  '${isChild ? 'Çocuk Modu' : 'Yetişkin Modu'} • 7 gün seri 🔥',
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          // İsim düzenleme
          GestureDetector(
            onTap: () => _showNameEditDialog(context, ref, userName),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit_outlined,
                  color: AppColors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _showNameEditDialog(
      BuildContext context, WidgetRef ref, String current) {
    final ctrl = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('İsmi Değiştir'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Kerem, Erkan, Ahmet...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('İptal',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              ref.read(nameProvider.notifier).state =
                  ctrl.text.trim();
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Grid ──────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.progress, required this.thisWeek});

  final Map<String, dynamic> progress;
  final Map<String, dynamic> thisWeek;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _Stat(
        icon: '⏱',
        label: 'Bu Hafta',
        value: '${thisWeek['totalMinutes']} dk',
        color: AppColors.primaryBg,
      ),
      _Stat(
        icon: '📖',
        label: 'Sureler',
        value: '${progress['surahsCompleted']}/${progress['surahsTotal']}',
        color: AppColors.primaryBg,
      ),
      _Stat(
        icon: '🤲',
        label: 'Dualar',
        value: '${thisWeek['duasLearned']}/${progress['duasTotal']}',
        color: AppColors.duaBg,
      ),
      _Stat(
        icon: '⭐',
        label: 'Yıldızlar',
        value: '${progress['totalStars']}',
        color: AppColors.rewardBg,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.0,
      children: stats
          .map((s) => Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: s.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(s.icon, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.value, style: AppTextStyles.titleLarge),
                        Text(s.label, style: AppTextStyles.labelSmall),
                      ],
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _Stat {
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final String icon;
  final String label;
  final String value;
  final Color color;
}

// ─── Settings widgets ─────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2C2A).withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMedium),
                  Text(subtitle,
                      style: AppTextStyles.labelSmall),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      color: AppColors.border,
    );
  }
}

class _LimitControl extends StatelessWidget {
  const _LimitControl({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: value > 10 ? () => onChanged(value - 10) : null,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.remove_rounded,
                size: 16, color: AppColors.textMuted),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('$value dk',
              style: AppTextStyles.labelLarge),
        ),
        GestureDetector(
          onTap: value < 120 ? () => onChanged(value + 10) : null,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary),
            ),
            child: const Icon(Icons.add_rounded,
                size: 16, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
