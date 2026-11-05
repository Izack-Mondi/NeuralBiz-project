import 'package:flutter/material.dart';

import '../../core/theme/neuralbiz_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilter,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: NeuralBizColors.textPrimary),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search services, products, opportunities...',
          hintStyle: const TextStyle(color: NeuralBizColors.textMuted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: NeuralBizColors.textSecondary,
          ),
          suffixIcon: IconButton(
            onPressed: onFilter,
            tooltip: 'Filter',
            icon: const Icon(
              Icons.tune_rounded,
              color: NeuralBizColors.brandPrimary,
            ),
          ),
          filled: true,
          fillColor: NeuralBizColors.backgroundElevated,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: NeuralBizColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: NeuralBizColors.brandPrimary,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
