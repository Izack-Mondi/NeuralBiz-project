import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_motion.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import '../common/nexify_pressable.dart';

enum NexifyConnectButtonState { idle, connecting, connected }

class NexifyConnectButton extends StatelessWidget {
  const NexifyConnectButton({
    super.key,
    required this.state,
    this.onPressed,
    this.fullWidth = false,
    this.height = 48,
  });

  final NexifyConnectButtonState state;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final double height;

  String get _label {
    switch (state) {
      case NexifyConnectButtonState.idle:
        return 'Connect';
      case NexifyConnectButtonState.connecting:
        return 'Connecting...';
      case NexifyConnectButtonState.connected:
        return 'Connected';
    }
  }

  bool get _isDisabled =>
      state == NexifyConnectButtonState.connected || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final isLoading = state == NexifyConnectButtonState.connecting;

    return NexifyPressable(
      enabled: !_isDisabled,
      child: AnimatedContainer(
        duration: NexifyMotion.duration(context, NexifyMotion.fast),
        curve: NexifyMotion.curveStandard,
        width: fullWidth ? double.infinity : null,
        height: height,
        constraints: fullWidth ? null : const BoxConstraints(minWidth: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(NexifyRadius.md),
          color: _isDisabled
              ? NexifyColors.backgroundElevated
              : NexifyColors.actionBlue,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(NexifyRadius.md),
            onTap: _isDisabled ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else if (state == NexifyConnectButtonState.connected)
                      const Icon(Icons.check, size: 18, color: Colors.white)
                    else
                      const Icon(
                        Icons.link_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    if (isLoading ||
                        state == NexifyConnectButtonState.connected ||
                        state == NexifyConnectButtonState.idle)
                      const SizedBox(width: 8),
                    Text(
                      _label,
                      style: NexifyTypography.buttonLabel.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
