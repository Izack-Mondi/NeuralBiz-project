import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import 'nexify_card.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.title,
    required this.provider,
    required this.price,
    this.onTap,
    this.description,
    this.icon,
  });

  final String title;
  final String provider;
  final String price;
  final VoidCallback? onTap;
  final String? description;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return NexifyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NexifyRadius.lg),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: NexifyColors.backgroundElevated,
              borderRadius: BorderRadius.circular(NexifyRadius.md),
            ),
            child: Icon(icon ?? Icons.handyman_outlined, color: NexifyColors.brandPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary)),
                const SizedBox(height: 4),
                Text(provider, style: NexifyTypography.bodySmall.copyWith(color: NexifyColors.textSecondary)),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(description!, style: NexifyTypography.bodySmall.copyWith(color: NexifyColors.textSecondary)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(price, style: NexifyTypography.labelLarge.copyWith(color: NexifyColors.brandPrimary)),
        ],
      ),
    );
  }
}
