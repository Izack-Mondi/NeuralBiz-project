import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';

class NexifySearchField extends StatelessWidget {
  const NexifySearchField({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: NexifyTypography.bodyMedium.copyWith(color: NexifyColors.textMuted),
        prefixIcon: const Icon(Icons.search_rounded, color: NexifyColors.textSecondary),
        filled: true,
        fillColor: NexifyColors.backgroundElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      ),
    );
  }
}
