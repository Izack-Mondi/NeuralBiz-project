import 'package:flutter/material.dart';

import '../../core/theme/nexify_colors.dart';
import '../../core/theme/nexify_radius.dart';
import '../../core/theme/nexify_typography.dart';
import 'nexify_card.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.onTap,
    this.imageUrl,
    this.location,
    this.tag,
  });

  final String name;
  final String price;
  final VoidCallback? onTap;
  final String? imageUrl;
  final String? location;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return NexifyCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(NexifyRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: NexifyColors.backgroundElevated,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(NexifyRadius.lg)),
              image: imageUrl != null && imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null || imageUrl!.isEmpty
                ? const Center(child: Icon(Icons.image_outlined, size: 28, color: NexifyColors.textMuted))
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tag != null && tag!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: NexifyColors.successSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag!,
                      style: NexifyTypography.labelMedium.copyWith(color: NexifyColors.brandPrimary),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(name, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.textPrimary)),
                const SizedBox(height: 6),
                if (location != null && location!.isNotEmpty)
                  Text(location!, style: NexifyTypography.bodySmall.copyWith(color: NexifyColors.textSecondary)),
                const SizedBox(height: 10),
                Text(price, style: NexifyTypography.titleMedium.copyWith(color: NexifyColors.brandPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
