import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';

class NexifyLoading extends StatelessWidget {
  const NexifyLoading({super.key, this.size = 28, this.strokeWidth = 3});

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: const AlwaysStoppedAnimation<Color>(NexifyColors.brandPrimary),
        ),
      ),
    );
  }
}
