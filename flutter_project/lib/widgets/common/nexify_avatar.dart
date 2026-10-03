import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';

class NexifyAvatar extends StatelessWidget {
  const NexifyAvatar({
    super.key,
    required this.label,
    this.size = 36,
    this.backgroundColor,
  });

  final String label;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final initials = label.trim().split(RegExp(r'\s+')).take(2).map((part) => part.substring(0, 1).toUpperCase()).join();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? NexifyColors.backgroundElevated,
        borderRadius: BorderRadius.circular(NexifyRadius.pill),
      ),
      child: Text(initials, style: TextStyle(color: NexifyColors.textPrimary, fontSize: size * 0.34, fontWeight: FontWeight.w700)),
    );
  }
}
