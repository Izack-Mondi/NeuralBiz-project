import 'package:flutter/material.dart';

import '../../core/theme/neuralbiz_colors.dart';

class EngagementRow extends StatelessWidget {
  const EngagementRow({
    super.key,
    required this.likes,
    required this.comments,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Action(icon: Icons.favorite_border_rounded, label: _format(likes), onTap: onLike),
        const SizedBox(width: 18),
        _Action(icon: Icons.mode_comment_outlined, label: _format(comments), onTap: onComment),
        const SizedBox(width: 18),
        _Action(icon: Icons.ios_share_rounded, label: 'Share', onTap: onShare),
        const Spacer(),
        IconButton(
          onPressed: onSave,
          tooltip: 'Save',
          icon: const Icon(Icons.bookmark_border_rounded, size: 21),
          color: NeuralBizColors.textSecondary,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  String _format(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: NeuralBizColors.textSecondary, size: 20),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: NeuralBizColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
