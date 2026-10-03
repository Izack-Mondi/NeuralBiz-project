import 'package:flutter/material.dart';

import 'nexify_text_field.dart';

class NexifyPriceField extends StatelessWidget {
  const NexifyPriceField({
    super.key,
    this.controller,
    this.labelText = 'Price',
    this.hintText = '0.00',
    this.onChanged,
  });

  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return NexifyTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: Icons.attach_money_rounded,
      onChanged: onChanged,
    );
  }
}
