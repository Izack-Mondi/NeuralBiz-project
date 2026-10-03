import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import 'nexify_card.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return NexifyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NexifyRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null && badge!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NexifyColors.brandPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(NexifyRadius.pill),
              ),
              child: Text(badge!, style: NexifyTypography.labelMedium.copyWith(color: NexifyColors.brandPrimary)),
            ),
          const SizedBox(height: 10),
          Text(title, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary)),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}
