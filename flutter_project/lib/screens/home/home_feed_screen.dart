import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neuralbiz_colors.dart';
import '../../data/api_client.dart';
import '../../data/feed_controller.dart';
import '../../data/opportunity_controller.dart';
import '../../models/opportunity_insight.dart';
import '../../widgets/cards/feed_post_card.dart';
import '../../widgets/cards/opportunity_card.dart';
import '../../widgets/cards/service_feed_card.dart';
import '../../widgets/feedback/neuralbiz_empty_state.dart';
import '../../widgets/feedback/neuralbiz_error_state.dart';
import '../../widgets/feedback/neuralbiz_loading.dart';
import '../../widgets/home/home_category_selector.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/home_search_bar.dart';
import '../app_shell.dart';
import '../market/product_details_screen.dart';
import '../market/service_details_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadController(_controllerForIndex(_tabController.index));
      final opportunities = context.read<OpportunityController>();
      if (opportunities.insights.isEmpty && !opportunities.isLoading) {
        opportunities.loadInitial();
      }
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _loadController(_controllerForIndex(_tabController.index));
  }

  FeedController _controllerForIndex(int index) {
    switch (index) {
      case 1:
        return context.read<BusinessFeedController>();
      case 2:
        return context.read<AgricultureFeedController>();
      default:
        return context.read<FeedController>();
    }
  }

  void _loadController(FeedController controller) {
    if (!controller.hasLoaded && !controller.isLoading) {
      controller.loadInitialFeed();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _search = value.trim().toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuralBizColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeHeader(
              onMessages: () => _showUnavailable('Messages are coming soon.'),
              onCart: () => AppShell.selectedIndex.value = 2,
            ),
            HomeSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onFilter: () => _showUnavailable('More filters are coming soon.'),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: HomeCategorySelector(
                controller: _tabController,
                onSelected: (index) => _loadController(_controllerForIndex(index)),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _FeedTab(
                    controller: context.read<FeedController>(),
                    search: _search,
                    showOpportunities: true,
                    onProductTap: _openProduct,
                  ),
                  _FeedTab(
                    controller: context.read<BusinessFeedController>(),
                    search: _search,
                    onProductTap: _openProduct,
                  ),
                  _FeedTab(
                    controller: context.read<AgricultureFeedController>(),
                    search: _search,
                    onProductTap: _openProduct,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProduct(FeedPost post) {
    final product = post.product;
    final service = post.service;
    if (product == null && service == null) return;

    final data = <String, dynamic>{
      'id': product?.id ?? service?.id ?? post.id,
      'listingId': product?.id ?? service?.id ?? post.id,
      'name': product?.name ?? service?.name ?? 'Listing',
      'seller': post.author.fullName,
      'sellerId': post.author.id,
      'location': product?.location ?? service?.location ?? post.author.location,
      'description': product?.description ?? service?.description,
      'price': product?.price.toString() ?? service?.price ?? 'Contact seller',
      'category': product?.category ?? service?.category ?? 'GENERAL',
      'type': service == null ? 'product' : 'service',
      'mediaUrl': post.mediaUrl,
      'thumbnailUrl': post.thumbnailUrl,
    };

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => service == null
            ? ProductDetailsScreen(product: data)
            : ServiceDetailsScreen(service: data),
      ),
    );
  }

  void _showUnavailable(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _FeedTab extends StatefulWidget {
  const _FeedTab({
    required this.controller,
    required this.search,
    required this.onProductTap,
    this.showOpportunities = false,
  });

  final FeedController controller;
  final String search;
  final bool showOpportunities;
  final ValueChanged<FeedPost> onProductTap;

  @override
  State<_FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<_FeedTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final posts = _filterPosts(widget.controller.posts, widget.search);
        if (widget.controller.isLoading && posts.isEmpty) {
          return const Center(child: NeuralBizLoading());
        }
        if (widget.controller.hasError && posts.isEmpty) {
          return NeuralBizErrorState(
            title: 'Feed unavailable',
            message: widget.controller.errorMessage ?? 'Failed to load feed.',
            onRetry: widget.controller.loadInitialFeed,
          );
        }
        final opportunities = widget.showOpportunities
            ? context.watch<OpportunityController>()
            : null;
        final insights = opportunities?.insights ?? const <OpportunityInsight>[];

        return RefreshIndicator(
          color: NeuralBizColors.brandPrimary,
          backgroundColor: NeuralBizColors.backgroundSurface,
          onRefresh: widget.controller.refreshFeed,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            children: [
              if (posts.isEmpty && insights.isEmpty)
                const SizedBox(
                  height: 300,
                  child: NeuralBizEmptyState(
                    title: 'Your feed is getting ready',
                    message: 'Explore the market and connect with businesses.',
                  ),
                ),
              for (final edge in posts) ...[
                _buildPost(edge.node),
                const SizedBox(height: 14),
              ],
              if (widget.showOpportunities) ...[
                _buildOpportunityHeading(),
                const SizedBox(height: 10),
                if (insights.isEmpty)
                  const OpportunityCard.mock()
                else
                  for (final insight in insights.take(3)) ...[
                    OpportunityCard.fromInsight(
                      insight: insight,
                      onTap: () => AppShell.selectedIndex.value = 3,
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
              if (widget.controller.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPost(FeedPost post) {
    if (post.type == 'SERVICE' && post.service != null) {
      return ServiceFeedCard(
        post: post,
        onLike: _notConnected,
        onComment: _notConnected,
        onShare: _notConnected,
        onSave: _notConnected,
        onViewService: () => widget.onProductTap(post),
        onContactProvider: () => widget.onProductTap(post),
      );
    }
    return FeedPostCard(
      post: post,
      onLike: _notConnected,
      onComment: _notConnected,
      onShare: _notConnected,
      onSave: _notConnected,
      onProductTap: () => widget.onProductTap(post),
    );
  }

  Widget _buildOpportunityHeading() {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            'Opportunities for you',
            style: TextStyle(
              color: NeuralBizColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Spacer(),
          Icon(Icons.auto_awesome, color: Color(0xFFA78BFA), size: 20),
        ],
      ),
    );
  }

  List<PostEdge> _filterPosts(List<PostEdge> posts, String query) {
    if (query.isEmpty) return posts;
    return posts.where((edge) {
      final post = edge.node;
      final values = [
        post.caption,
        post.author.fullName,
        post.author.location,
        post.offering?['title']?.toString(),
        post.service?.name,
        post.service?.category,
        post.product?.name,
        post.product?.category,
      ];
      return values.any(
        (value) => value != null && value.toLowerCase().contains(query),
      );
    }).toList();
  }

  void _notConnected() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This action will be available when engagement is connected.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
