import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_motion.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import '../common/nexify_pressable.dart';

class NexifySecondaryButton extends StatelessWidget {
  const NexifySecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
    this.disabled = false,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool fullWidth;
  final bool disabled;
  final double height;

  bool get _isDisabled => disabled || loading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                NexifyColors.brandPrimary,
              ),
            ),
          )
        else if (icon != null)
          Icon(icon, size: 18, color: NexifyColors.brandPrimary)
        else
          const SizedBox.shrink(),
        if ((loading || icon != null)) const SizedBox(width: 8),
        Text(
          label,
          style: NexifyTypography.buttonLabel.copyWith(
            color: NexifyColors.textPrimary,
          ),
        ),
      ],
    );

    return NexifyPressable(
      enabled: !_isDisabled,
      child: AnimatedContainer(
        duration: NexifyMotion.duration(context, NexifyMotion.fast),
        curve: NexifyMotion.curveStandard,
        width: fullWidth ? double.infinity : null,
        height: height,
        constraints: fullWidth ? null : const BoxConstraints(minWidth: 150),
        decoration: BoxDecoration(
          color: NexifyColors.backgroundElevated,
          borderRadius: BorderRadius.circular(NexifyRadius.md),
          border: Border.all(
            color: NexifyColors.borderStrong.withValues(alpha: 0.7),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(NexifyRadius.md),
            onTap: _isDisabled ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
