import 'package:flutter/material.dart';

import '../../core/theme/nexify_motion.dart';

class NexifyPressable extends StatefulWidget {
  const NexifyPressable({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<NexifyPressable> createState() => _NexifyPressableState();
}

class _NexifyPressableState extends State<NexifyPressable> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (!widget.enabled || _pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? NexifyMotion.pressScale(context) : 1,
        duration: NexifyMotion.duration(context, NexifyMotion.micro),
        curve: NexifyMotion.curveStandard,
        child: widget.child,
      ),
    );
  }
}
