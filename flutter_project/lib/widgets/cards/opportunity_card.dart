import 'package:flutter/material.dart';

import '../../core/theme/neuralbiz_colors.dart';
import '../../core/theme/neuralbiz_radius.dart';
import '../../core/theme/neuralbiz_shadows.dart';
import '../../models/opportunity_insight.dart';

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
    required this.organization,
    required this.title,
    required this.description,
    required this.funding,
    required this.location,
    required this.deadline,
    this.onTap,
  });

  const OpportunityCard.mock({super.key, this.onTap})
    : organization = 'Kenya Innovation Hub',
      title = 'Agricultural Innovation Fund',
      description =
          'Funding opportunities supporting innovative agricultural businesses and technology solutions.',
      funding = 'Up to KES 5,000,000',
      location = 'Kenya',
      deadline = 'Closes in 18 days';

  factory OpportunityCard.fromInsight({
    Key? key,
    required OpportunityInsight insight,
    VoidCallback? onTap,
  }) {
    final payload = insight.payload;
    return OpportunityCard(
      key: key,
      organization: payload['organization']?.toString() ?? insight.category,
      title: payload['title']?.toString() ?? insight.key,
      description: payload['description']?.toString() ??
          'A new opportunity matched to your interests.',
      funding: payload['funding']?.toString() ?? 'View funding details',
      location: payload['location']?.toString() ?? insight.region,
      deadline: payload['deadline']?.toString() ?? 'Explore now',
      onTap: onTap,
    );
  }

  final String organization;
  final String title;
  final String description;
  final String funding;
  final String location;
  final String deadline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF171329), NeuralBizColors.backgroundSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(NeuralBizRadius.lg),
        border: Border.all(color: const Color(0xFF6D5BB3).withValues(alpha: 0.4)),
        boxShadow: NeuralBizShadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFA78BFA),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    organization,
                    style: const TextStyle(
                      color: NeuralBizColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.more_horiz, color: NeuralBizColors.textMuted),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: NeuralBizColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: NeuralBizColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Meta(icon: Icons.payments_outlined, text: funding),
                _Meta(icon: Icons.location_on_outlined, text: location),
                _Meta(icon: Icons.schedule_outlined, text: deadline),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFA78BFA),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'View opportunity',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFA78BFA)),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: NeuralBizColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
