import 'package:flutter/material.dart';

class NexifyMotion {
  NexifyMotion._();

  static const Duration micro = Duration(milliseconds: 140);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 260);
  static const Duration emphasis = Duration(milliseconds: 320);
  static const Duration modal = Duration(milliseconds: 280);

  // Backwards-compatible aliases for existing components.
  static const Duration instant = micro;
  static const Duration quick = fast;
  static const Duration slow = emphasis;

  static const Curve curveStandard = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeInOutCubic;
  static const Curve curveReverse = Curves.easeInCubic;

  static Duration duration(BuildContext context, Duration value) {
    return MediaQuery.of(context).disableAnimations ? Duration.zero : value;
  }

  static double pressScale(BuildContext context) {
    return MediaQuery.of(context).disableAnimations ? 1 : 0.985;
  }
}
