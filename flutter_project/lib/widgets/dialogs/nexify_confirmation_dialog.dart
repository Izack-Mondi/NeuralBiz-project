import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_typography.dart';
import '../buttons/nexify_danger_button.dart';

Future<bool?> showNexifyConfirmationDialog({
  required BuildContext context,
  required String title,
  String? message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  VoidCallback? onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: NexifyColors.backgroundSurface,
      title: Text(title, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary)),
      content: message != null ? Text(message, style: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textSecondary)) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel, style: NexifyTypography.labelLarge.copyWith(color: NexifyColors.textSecondary)),
        ),
        NexifyDangerButton(
          label: confirmLabel,
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    ),
  );
}
