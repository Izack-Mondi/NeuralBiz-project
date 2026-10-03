import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_motion.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import '../common/nexify_pressable.dart';

class NexifyTabBar extends StatelessWidget {
  const NexifyTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NexifyColors.backgroundElevated,
        borderRadius: BorderRadius.circular(NexifyRadius.md),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: NexifyPressable(
              enabled: onTap != null,
              child: GestureDetector(
                onTap: () => onTap?.call(index),
                child: AnimatedContainer(
                  duration: NexifyMotion.duration(
                    context,
                    NexifyMotion.standard,
                  ),
                  curve: NexifyMotion.curveStandard,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? NexifyColors.brandPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(NexifyRadius.sm),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    style: NexifyTypography.labelLarge.copyWith(
                      color: selected
                          ? Colors.white
                          : NexifyColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
