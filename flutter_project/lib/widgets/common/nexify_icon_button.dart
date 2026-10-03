import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_motion.dart';
import '../../core/theme/nexify_radius.dart';
import 'nexify_pressable.dart';

class NexifyIconButton extends StatelessWidget {
  const NexifyIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return NexifyPressable(
      enabled: onPressed != null,
      child: AnimatedContainer(
        duration: NexifyMotion.duration(context, NexifyMotion.fast),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? NexifyColors.backgroundElevated,
          borderRadius: BorderRadius.circular(NexifyRadius.md),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(NexifyRadius.md),
            onTap: onPressed,
            child: Center(child: Icon(icon, color: NexifyColors.textPrimary)),
          ),
        ),
      ),
    );
  }
}
