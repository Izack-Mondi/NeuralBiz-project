import 'package:flutter/material.dart';

class NexifyCollapsingScrollView extends StatelessWidget {
  const NexifyCollapsingScrollView({
    super.key,
    required this.header,
    required this.content,
    this.fillRemaining = false,
  });

  final Widget header;
  final Widget content;
  final bool fillRemaining;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: header),
        if (fillRemaining)
          SliverFillRemaining(child: content)
        else
          SliverToBoxAdapter(child: content),
      ],
    );
  }
}
