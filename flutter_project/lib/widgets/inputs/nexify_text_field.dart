import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';

class NexifyTextField extends StatelessWidget {
  const NexifyTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty) ...[
          Text(
            labelText!,
            style: NexifyTypography.labelLarge.copyWith(
              color: NexifyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          style: NexifyTypography.bodyMedium.copyWith(
            color: NexifyColors.textPrimary,
          ),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: NexifyTypography.bodyMedium.copyWith(
              color: NexifyColors.textMuted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: NexifyColors.textSecondary)
                : null,
            suffixIcon: suffixIcon,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NexifyRadius.md),
              borderSide: const BorderSide(color: NexifyColors.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NexifyRadius.md),
              borderSide: const BorderSide(color: NexifyColors.danger),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NexifyRadius.md),
              borderSide: const BorderSide(color: NexifyColors.disabled),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NexifyRadius.md),
              borderSide: const BorderSide(color: NexifyColors.brandPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
