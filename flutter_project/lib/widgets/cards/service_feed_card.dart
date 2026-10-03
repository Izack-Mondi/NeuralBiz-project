import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/api_client.dart';
import 'lazy_video_player.dart';

class ServiceFeedCard extends StatelessWidget {
  final FeedPost post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onViewService;
  final VoidCallback? onContactProvider;

  const ServiceFeedCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
    this.onViewService,
    this.onContactProvider,
  });

  @override
  Widget build(BuildContext context) {
    final service = post.service;
    if (service == null) return const SizedBox.shrink();

    return Card(
      color: const Color(0xFF0A0F1C),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildVideo(),
          _buildServiceInfo(),
          _buildPrimaryActions(),
          _buildSecondaryActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF22C55E),
            child: Text(
              post.author.fullName[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    if (post.author.location != null) ...[
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF8A8C92),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.author.location!,
                        style: const TextStyle(
                          color: Color(0xFF8A8C92),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(post.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF8A8C92),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildRatingBadge(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    final service = post.service!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA500).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Color(0xFFFFA500),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            service.rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Color(0xFFFFA500),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideo() {
    if (post.mediaUrl == null && post.mediaType == 'TEXT') {
      return const SizedBox.shrink();
    }

    if (post.mediaType == 'VIDEO') {
      return LazyVideoPlayer(
        videoUrl: post.mediaUrl!,
        thumbnailUrl: post.thumbnailUrl,
      );
    }

    return _buildImage();
  }

  Widget _buildImage() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111214),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: post.thumbnailUrl != null || post.mediaUrl != null
            ? Image.network(
                post.thumbnailUrl ?? post.mediaUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Color(0xFF22C55E),
                      size: 50,
                    ),
                  );
                },
              )
            : const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Color(0xFF22C55E),
                  size: 50,
                ),
              ),
      ),
    );
  }

  Widget _buildServiceInfo() {
    final service = post.service!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              service.category,
              style: const TextStyle(
                color: Color(0xFF22C55E),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (service.description != null && service.description!.isNotEmpty)
            Text(
              service.description!,
              style: const TextStyle(
                color: Color(0xFFD7D8DC),
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (service.location != null) ...[
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF8A8C92),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  service.location!,
                  style: const TextStyle(
                    color: Color(0xFF8A8C92),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              if (service.price != null) ...[
                const Icon(
                  Icons.payments_outlined,
                  color: Color(0xFF8A8C92),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  service.price!,
                  style: const TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onViewService,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Service',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: onContactProvider,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF22C55E),
                side: const BorderSide(color: Color(0xFF22C55E)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Contact Provider',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.favorite_border,
            count: post.likesCount,
            onTap: onLike,
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            count: post.commentsCount,
            onTap: onComment,
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            icon: Icons.share_outlined,
            count: null,
            onTap: onShare,
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            icon: Icons.bookmark_border,
            count: null,
            onTap: onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int? count,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          if (count != null) ...[
            const SizedBox(width: 6),
            Text(
              _formatCount(count),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
