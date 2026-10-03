import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_typography.dart';

class NexifyErrorState extends StatelessWidget {
  const NexifyErrorState({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 46, color: NexifyColors.danger),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: NexifyTypography.titleMedium.copyWith(
                color: NexifyColors.textPrimary,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: NexifyTypography.bodyMedium.copyWith(
                  color: NexifyColors.textSecondary,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              FilledButton.tonal(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: NexifyColors.brandPrimary,
                  foregroundColor: NexifyColors.textPrimary,
                  minimumSize: const Size(144, 44),
                ),
                child: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
