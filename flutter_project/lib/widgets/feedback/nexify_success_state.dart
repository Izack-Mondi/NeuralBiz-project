import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_motion.dart';
import '../../core/theme/nexify_typography.dart';

class NexifySuccessState extends StatelessWidget {
  const NexifySuccessState({super.key, required this.title, this.message});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: NexifyMotion.duration(context, NexifyMotion.emphasis),
        curve: NexifyMotion.curveStandard,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.98 + (0.02 * value), child: child),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 46,
                color: NexifyColors.success,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
