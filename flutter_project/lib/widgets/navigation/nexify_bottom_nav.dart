import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_motion.dart';
import '../../core/theme/nexify_typography.dart';

class NexifyBottomNavItem {
  const NexifyBottomNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
}

class NexifyBottomNav extends StatelessWidget {
  const NexifyBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
  });

  final List<NexifyBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: NexifyColors.backgroundSurface,
      selectedItemColor: NexifyColors.brandPrimary,
      unselectedItemColor: NexifyColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: NexifyTypography.labelMedium,
      unselectedLabelStyle: NexifyTypography.labelMedium,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: NexifyMotion.duration(context, NexifyMotion.fast),
                switchInCurve: NexifyMotion.curveStandard,
                switchOutCurve: NexifyMotion.curveReverse,
                child: Icon(
                  currentIndex == items.indexOf(item)
                      ? (item.activeIcon ?? item.icon)
                      : item.icon,
                  key: ValueKey<bool>(currentIndex == items.indexOf(item)),
                ),
              ),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}
