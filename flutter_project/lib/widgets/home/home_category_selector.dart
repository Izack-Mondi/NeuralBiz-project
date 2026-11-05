import 'package:flutter/material.dart';

import '../../core/theme/neuralbiz_colors.dart';

class HomeCategorySelector extends StatelessWidget {
  const HomeCategorySelector({
    super.key,
    required this.controller,
    required this.onSelected,
  });

  final TabController controller;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      onTap: onSelected,
      isScrollable: true,
      dividerColor: Colors.transparent,
      indicator: const BoxDecoration(),
      labelPadding: const EdgeInsets.only(right: 10),
      tabAlignment: TabAlignment.start,
      tabs: [
        _CategoryTab(
          label: 'All',
          icon: Icons.grid_view_rounded,
          controller: controller,
        ),
        _CategoryTab(
          label: 'Business',
          icon: Icons.business_center_outlined,
          controller: controller,
        ),
        _CategoryTab(
          label: 'Agriculture',
          icon: Icons.agriculture_outlined,
          controller: controller,
        ),
      ],
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.controller,
  });

  final String label;
  final IconData icon;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final color = label == 'Business'
        ? const Color(0xFFF472B6)
        : NeuralBizColors.brandPrimary;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final active = controller.index == _indexFor(label);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: 0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? color : NeuralBizColors.borderStrong,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: active ? color : NeuralBizColors.textMuted),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: active ? color : NeuralBizColors.textSecondary,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _indexFor(String value) {
    switch (value) {
      case 'Business':
        return 1;
      case 'Agriculture':
        return 2;
      default:
        return 0;
    }
  }
}
