import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import '../common/nexify_avatar.dart';
import 'nexify_card.dart';

class ConnectionCard extends StatelessWidget {
  const ConnectionCard({
    super.key,
    required this.name,
    this.role,
    this.onTap,
  });

  final String name;
  final String? role;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return NexifyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NexifyRadius.lg),
      child: Row(
        children: [
          NexifyAvatar(label: name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary)),
                if (role != null && role!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(role!, style: NexifyTypography.bodySmall.copyWith(color: NexifyColors.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
