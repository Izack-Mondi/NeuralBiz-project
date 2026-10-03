import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_shadows.dart';
import '../../core/theme/nexify_spacing.dart';
import '../common/nexify_pressable.dart';

class NexifyCard extends StatelessWidget {
  const NexifyCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.elevation,
    this.onTap,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final double? elevation;
  final VoidCallback? onTap;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(NexifyRadius.md);
    final cardPadding = padding ?? const EdgeInsets.all(NexifySpacing.md);
    final cardBorder =
        border ??
        Border.all(
          color: (borderColor ?? NexifyColors.border).withValues(alpha: 0.8),
        );

    final body = Container(
      margin: margin,
      padding: cardPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? NexifyColors.backgroundSurface,
        borderRadius: radius,
        border: cardBorder,
        boxShadow: elevation != null && elevation! > 0
            ? NexifyShadows.card
            : null,
      ),
      child: child,
    );

    if (onTap == null) {
      return body;
    }

    return NexifyPressable(
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: NexifyColors.brandPrimary.withValues(alpha: 0.12),
          highlightColor: NexifyColors.brandPrimary.withValues(alpha: 0.08),
          child: body,
        ),
      ),
    );
  }
}
