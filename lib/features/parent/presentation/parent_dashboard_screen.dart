import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../mocks/mock_parent.dart';
import '../../../mocks/mock_progress.dart';
import '../../../shared/widgets/weekly_bar_chart.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() =>
      _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
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
    final child = mockParent['child'] as Map<String, dynamic>;
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
              childName: child['name'] as String,
              onClose: () => context.go('/child/home'),
            ),

            // ─── Çocuk profil kartı ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _ChildProfileCard(
                child: child,
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
              child: Column(
                children: [
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
                ],
              ),
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
  const _ParentHeader({
    required this.childName,
    required this.onClose,
  });

  final String childName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
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
                      'Ebeveyn Panosu',
                      style: AppTextStyles.headlineMedium
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      '$childName\'in gelişimi',
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

// ─── Child Profile Card ──────────────────────────────────────────────────────

class _ChildProfileCard extends StatelessWidget {
  const _ChildProfileCard({
    required this.child,
    required this.thisWeek,
  });

  final Map<String, dynamic> child;
  final Map<String, dynamic> thisWeek;

  @override
  Widget build(BuildContext context) {
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
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                child['avatar'] as String,
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
                  child['name'] as String,
                  style: AppTextStyles.titleLarge
                      .copyWith(color: AppColors.white),
                ),
                Text(
                  '${child['age']} yaşında • ${child['streakDays']} gün seri 🔥',
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
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
