import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/api_client.dart';
import 'lazy_video_player.dart';

class FeedPostCard extends StatelessWidget {
  final FeedPost post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onProductTap;

  const FeedPostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
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
          if (post.caption != null && post.caption!.isNotEmpty)
            _buildCaption(),
          _buildMedia(),
          if (post.product != null) _buildProductInfo(),
          _buildActions(),
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
                if (post.author.location != null)
                  Text(
                    post.author.location!,
                    style: const TextStyle(
                      color: Color(0xFF8A8C92),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          _buildPostTypeBadge(),
        ],
      ),
    );
  }

  Widget _buildPostTypeBadge() {
    Color badgeColor;
    String badgeText;

    switch (post.type) {
      case 'MARKETPLACE':
        badgeColor = const Color(0xFF22C55E);
        badgeText = 'MARKET';
        break;
      case 'OPPORTUNITY':
        badgeColor = const Color(0xFF3B82F6);
        badgeText = 'OPPORTUNITY';
        break;
      default:
        badgeColor = const Color(0xFF8A8C92);
        badgeText = 'GENERAL';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        post.caption!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildMedia() {
    if (post.mediaUrl == null && post.mediaType == 'TEXT') {
      return const SizedBox.shrink();
    }

    if (post.mediaType == 'VIDEO') {
      return _buildVideoPlayer();
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

  Widget _buildVideoPlayer() {
    if (post.mediaUrl == null) {
      return Container(
        height: 300,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111214),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.video_library_outlined,
            color: Color(0xFF22C55E),
            size: 50,
          ),
        ),
      );
    }

    return LazyVideoPlayer(
      videoUrl: post.mediaUrl!,
      thumbnailUrl: post.thumbnailUrl,
    );
  }

  Widget _buildProductInfo() {
    final product = post.product!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111214),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF22C55E), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF8A8C92),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.location ?? 'Location not specified',
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
          const SizedBox(width: 12),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: onProductTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
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
          const Spacer(),
          Text(
            _formatDate(post.createdAt),
            style: const TextStyle(
              color: Color(0xFF8A8C92),
              fontSize: 12,
            ),
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
          Icon(icon, color: Colors.white, size: 24),
          if (count != null) ...[
            const SizedBox(width: 8),
            Text(
              _formatCount(count),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
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