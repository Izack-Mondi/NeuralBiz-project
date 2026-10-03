import 'package:flutter/material.dart';

import 'nexify_text_field.dart';

class NexifyLocationField extends StatelessWidget {
  const NexifyLocationField({
    super.key,
    this.controller,
    this.labelText = 'Location',
    this.hintText = 'Enter a city or region',
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
      prefixIcon: Icons.location_on_outlined,
      onChanged: onChanged,
    );
  }
}
