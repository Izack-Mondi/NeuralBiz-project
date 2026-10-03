import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_motion.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import '../common/nexify_pressable.dart';

class NexifyCategorySelector extends StatelessWidget {
  const NexifyCategorySelector({
    super.key,
    required this.items,
    required this.selected,
    this.onSelected,
  });

  final List<String> items;
  final String selected;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = item == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: NexifyPressable(
              enabled: onSelected != null,
              child: GestureDetector(
                onTap: () => onSelected?.call(item),
                child: AnimatedContainer(
                  duration: NexifyMotion.duration(
                    context,
                    NexifyMotion.standard,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? NexifyColors.brandPrimary
                        : NexifyColors.backgroundElevated,
                    borderRadius: BorderRadius.circular(NexifyRadius.pill),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : NexifyColors.border,
                    ),
                  ),
                  child: Text(
                    item,
                    style: NexifyTypography.labelLarge.copyWith(
                      color: isSelected
                          ? Colors.white
                          : NexifyColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
