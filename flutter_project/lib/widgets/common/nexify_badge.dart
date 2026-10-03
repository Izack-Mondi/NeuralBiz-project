import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';

class NexifyBadge extends StatelessWidget {
  const NexifyBadge({
    super.key,
    required this.label,
    this.color = NexifyColors.successSoft,
    this.textColor = NexifyColors.brandPrimary,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(NexifyRadius.pill),
      ),
      child: Text(
        label,
        style: NexifyTypography.labelMedium.copyWith(color: textColor),
      ),
    );
  }
}
