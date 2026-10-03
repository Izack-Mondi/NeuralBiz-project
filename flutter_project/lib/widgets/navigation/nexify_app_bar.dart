import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_typography.dart';

class NexifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NexifyAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: NexifyColors.background,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      title: title != null ? Text(title!, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary)) : null,
      centerTitle: centerTitle,
      actions: actions,
      elevation: 0,
    );
  }
}
