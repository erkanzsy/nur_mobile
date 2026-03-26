import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ChildShell extends StatelessWidget {
  const ChildShell({super.key, required this.child});

  final Widget child;

  int _tabIndex(String location) {
    if (location.startsWith('/child/surahs')) return 1;
    if (location.startsWith('/child/duas')) return 2;
    if (location.startsWith('/child/stories')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/child/home');
      case 1: context.go('/child/surahs');
      case 2: context.go('/child/duas');
      case 3: context.go('/child/stories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _tabIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _Tab(
                  icon: Icons.home_rounded,
                  iconOutlined: Icons.home_outlined,
                  label: 'Ana Sayfa',
                  selected: index == 0,
                  onTap: () => _onTap(context, 0),
                ),
                _Tab(
                  icon: Icons.menu_book_rounded,
                  iconOutlined: Icons.menu_book_outlined,
                  label: 'Sureler',
                  selected: index == 1,
                  onTap: () => _onTap(context, 1),
                ),
                _Tab(
                  icon: Icons.volunteer_activism,
                  iconOutlined: Icons.volunteer_activism_outlined,
                  label: 'Dualar',
                  selected: index == 2,
                  onTap: () => _onTap(context, 2),
                ),
                _Tab(
                  icon: Icons.auto_stories,
                  iconOutlined: Icons.auto_stories_outlined,
                  label: 'Kıssalar',
                  selected: index == 3,
                  onTap: () => _onTap(context, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.iconOutlined,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData iconOutlined;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textMuted;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                selected ? icon : iconOutlined,
                key: ValueKey(selected),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
