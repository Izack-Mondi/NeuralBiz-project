import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';

class NexifyDivider extends StatelessWidget {
  const NexifyDivider({super.key, this.height = 1, this.color = NexifyColors.border});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, thickness: height, color: color);
  }
}
