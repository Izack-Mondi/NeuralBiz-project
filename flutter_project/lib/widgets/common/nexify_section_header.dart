import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_typography.dart';

class NexifySectionHeader extends StatelessWidget {
  const NexifySectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary)),
              subtitle?.isNotEmpty == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(subtitle!, style: NexifyTypography.bodySmall.copyWith(color: NexifyColors.textSecondary)),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        action ?? const SizedBox.shrink(),
      ],
    );
  }
}
