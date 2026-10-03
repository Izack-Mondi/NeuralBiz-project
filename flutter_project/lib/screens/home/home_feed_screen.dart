import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/feed_controller.dart';
import '../../widgets/cards/feed_post_card.dart';
import '../../widgets/cards/service_feed_card.dart';
import '../../widgets/feedback/nexify_empty_state.dart';
import '../../widgets/feedback/nexify_error_state.dart';
import '../../widgets/feedback/nexify_loading.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeFeed();
  }

  void _initializeFeed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedController = context.read<FeedController>();
      feedController.loadInitialFeed();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final feedController = context.read<FeedController>();
    
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (feedController.hasNextPage && !feedController.isLoadingMore) {
        feedController.loadMoreFeed();
      }
    }
  }

  Future<void> _onRefresh() async {
    final feedController = context.read<FeedController>();
    await feedController.refreshFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildCategories(),
            Expanded(
              child: Consumer<FeedController>(
                builder: (context, feedController, child) {
                  if (feedController.isLoading && feedController.posts.isEmpty) {
                    return const Center(child: NexifyLoading());
                  }

                  if (feedController.hasError) {
                    return Center(
                      child: NexifyErrorState(
                        title: 'Feed Error',
                        message: feedController.errorMessage ?? 'Failed to load feed',
                        onRetry: () {
                          feedController.clearError();
                          feedController.loadInitialFeed();
                        },
                      ),
                    );
                  }

                  if (feedController.posts.isEmpty) {
                    return const Center(
                      child: NexifyEmptyState(
                        title: 'Your Nexify feed is getting ready',
                        message: 'Connect with people, explore the market,\nand discover new opportunities.',
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: const Color(0xFF22C55E),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: feedController.posts.length + 
                          (feedController.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= feedController.posts.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                color: Color(0xFF22C55E),
                              ),
                            ),
                          );
                        }

                        final post = feedController.posts[index].node;
                        
                        // Use service card for SERVICE type, regular card for others
                        if (post.type == 'SERVICE' && post.service != null) {
                          return ServiceFeedCard(
                            post: post,
                            onLike: () {
                              // TODO: Implement like functionality
                            },
                            onComment: () {
                              // TODO: Implement comment functionality
                            },
                            onShare: () {
                              // TODO: Implement share functionality
                            },
                            onSave: () {
                              // TODO: Implement save functionality
                            },
                            onViewService: () {
                              // TODO: Navigate to service details
                            },
                            onContactProvider: () {
                              // TODO: Navigate to provider contact
                            },
                          );
                        }
                        
                        return FeedPostCard(
                          post: post,
                          onLike: () {
                            // TODO: Implement like functionality
                          },
                          onComment: () {
                            // TODO: Implement comment functionality
                          },
                          onShare: () {
                            // TODO: Implement share functionality
                          },
                          onProductTap: () {
                            // TODO: Navigate to product details
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 18, 8),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white, size: 34),

          const SizedBox(width: 22),

          Expanded(
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFF111214),
                borderRadius: BorderRadius.circular(32),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'Search anything on Nexify...',
                style: TextStyle(
                  color: Color(0xFF85878D),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 35,
              ),
              Positioned(
                top: -10,
                right: -7,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '8',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Agriculture', 'Business', 'Nearby'];
    int selectedIndex = 0;

    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              // TODO: Filter feed by category
            },
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF111214),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: TextStyle(
                  color: selected ? Colors.black : const Color(0xFFD7D8DC),
                  fontSize: 17,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}