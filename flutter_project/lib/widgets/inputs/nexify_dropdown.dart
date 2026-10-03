import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';

class NexifyDropdown<T> extends StatelessWidget {
  const NexifyDropdown({
    super.key,
    required this.items,
    required this.value,
    this.hint,
    this.onChanged,
    this.labelText,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty) ...[
          Text(labelText!, style: NexifyTypography.labelLarge.copyWith(color: NexifyColors.textPrimary)),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          hint: hint != null ? Text(hint!, style: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textMuted)) : null,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.expand_more_rounded, color: NexifyColors.textSecondary),
          decoration: InputDecoration(
            filled: true,
            fillColor: NexifyColors.backgroundElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NexifyRadius.md),
              borderSide: const BorderSide(color: NexifyColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NexifyRadius.md),
              borderSide: const BorderSide(color: NexifyColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NexifyRadius.md),
              borderSide: const BorderSide(color: NexifyColors.brandPrimary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
          dropdownColor: NexifyColors.backgroundElevated,
          style: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textPrimary),
        ),
      ],
    );
  }
}
