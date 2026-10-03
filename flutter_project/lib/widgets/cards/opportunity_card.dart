import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import 'nexify_card.dart';

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
    this.meta,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;
  final String? meta;

  @override
  Widget build(BuildContext context) {
    return NexifyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NexifyRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: NexifyTypography.titleLarge.copyWith(color: NexifyColors.textPrimary)),
          if (meta != null && meta!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(meta!, style: NexifyTypography.bodySmall.copyWith(color: NexifyColors.textMuted)),
          ],
        ],
      ),
    );
  }
}
