import 'package:flutter/material.dart';

import '../../core/theme/neuralbiz_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.onMessages,
    this.onCart,
  });

  final VoidCallback? onMessages;
  final VoidCallback? onCart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Neural', style: TextStyle(color: Colors.white)),
                TextSpan(
                  text: 'Biz',
                  style: TextStyle(color: NeuralBizColors.brandPrimary),
                ),
              ],
            ),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const Spacer(),
          _HeaderAction(
            icon: Icons.chat_bubble_outline_rounded,
            badge: '2',
            tooltip: 'Messages',
            onPressed: onMessages,
          ),
          const SizedBox(width: 8),
          _HeaderAction(
            icon: Icons.shopping_bag_outlined,
            badge: '3',
            tooltip: 'Market',
            onPressed: onCart,
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.badge,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String badge;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          tooltip: tooltip,
          icon: Icon(icon, color: NeuralBizColors.textPrimary, size: 22),
          style: IconButton.styleFrom(
            backgroundColor: NeuralBizColors.backgroundElevated,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: NeuralBizColors.border),
            ),
          ),
        ),
        Positioned(
          right: -2,
          top: -3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: const BoxDecoration(
              color: NeuralBizColors.brandPrimary,
              shape: BoxShape.circle,
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
