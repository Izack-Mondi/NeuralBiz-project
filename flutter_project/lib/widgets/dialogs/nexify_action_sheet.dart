import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';

Future<T?> showNexifyActionSheet<T>({
  required BuildContext context,
  required List<Widget> actions,
  String? title,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: NexifyColors.backgroundSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(title, style: const TextStyle(color: NexifyColors.textPrimary)),
              ),
            ...actions,
          ],
        ),
      ),
    ),
  );
}
