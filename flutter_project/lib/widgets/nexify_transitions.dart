import 'package:flutter/material.dart';

import '../core/theme/nexify_motion.dart';

class NexifyTransitions {
  static const Duration pageDuration = NexifyMotion.standard;
  static const Duration modalDuration = NexifyMotion.modal;
  static const Curve motionCurve = NexifyMotion.curveStandard;

  static PageRoute<T> fadeSlide<T>(Widget page, {bool horizontal = false}) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, _, _) => page,
      transitionDuration: pageDuration,
      reverseTransitionDuration: NexifyMotion.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final reducedMotion = MediaQuery.of(context).disableAnimations;
        final curved = CurvedAnimation(
          parent: animation,
          curve: motionCurve,
          reverseCurve: NexifyMotion.curveReverse,
        );

        final begin = horizontal
            ? const Offset(0.08, 0)
            : const Offset(0, 0.04);

        final transition = FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).chain(CurveTween(curve: motionCurve)).animate(animation),
            child: child,
          ),
        );
        return reducedMotion
            ? FadeTransition(opacity: animation, child: child)
            : transition;
      },
    );
  }

  static PageRoute<T> modal<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, _, _) => page,
      transitionDuration: modalDuration,
      reverseTransitionDuration: NexifyMotion.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final reducedMotion = MediaQuery.of(context).disableAnimations;
        final curved = CurvedAnimation(
          parent: animation,
          curve: motionCurve,
          reverseCurve: NexifyMotion.curveReverse,
        );

        final transition = FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.96,
              end: 1.0,
            ).chain(CurveTween(curve: motionCurve)).animate(animation),
            child: child,
          ),
        );
        return reducedMotion
            ? FadeTransition(opacity: animation, child: child)
            : transition;
      },
    );
  }
}
