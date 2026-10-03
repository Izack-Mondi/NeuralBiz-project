import 'package:flutter/material.dart';

class NexifyShadows {
  NexifyShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> raised = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 12),
      blurRadius: 30,
      spreadRadius: -4,
    ),
  ];
}
