import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/nexify_transitions.dart';
import 'seller_profile_screen.dart';
import '_video_overlay.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideoIfPresent();
  }

  Future<void> _initVideoIfPresent() async {
    final videoFile = widget.product['videoFilePath'] as String?;
    final videoLink = widget.product['videoLink'] as String?;

    try {
      if (videoFile != null && videoFile.isNotEmpty) {
        _videoController = VideoPlayerController.file(File(videoFile));
      } else if (videoLink != null && videoLink.startsWith('http')) {
        _videoController = VideoPlayerController.networkUrl(Uri.parse(videoLink));
      }

      if (_videoController != null) {
        await _videoController!.initialize();
        _videoController!.setLooping(false);
        setState(() => _videoInitialized = true);
      }
    } catch (e) {
      // ignore video init errors
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final String name = product['name'] ?? 'Product';
    final String seller = product['seller'] ?? 'Seller';
    final String location =
        product['location'] ?? 'Location unavailable';
    final String price =
        product['price'] ?? 'Price unavailable';
    final String unit = product['unit'] ?? '';
    final String available =
        product['available'] ?? 'Availability unavailable';
    final String rating = product['rating'] ?? '0.0';
    final String reviews = product['reviews'] ?? '0';
    final String category =
        product['category'] ?? 'GENERAL';
    final String type = product['type'] ?? 'product';
    final bool isSaleRequest = type == 'request';
    final bool isProductRequest = isSaleRequest;
    final bool isService = type == 'service';
    final String customSpecialization =
        (product['customSpecialization'] ?? '').toString();
    final String categoryLabel = customSpecialization.isNotEmpty
        ? customSpecialization
        : isProductRequest
            ? (product['categoryName'] ?? category)
            : isService
                ? (product['displayCategory'] ?? category)
                : category;
    final String badgeLabel = isProductRequest
        ? 'PRODUCT REQUEST'
        : isService
            ? 'SERVICE'
            : 'PRODUCT';
    final String priceLabel = isProductRequest
        ? 'Budget'
        : isService
            ? 'Rate'
            : 'Price';
    final String availabilityLabel = isProductRequest
        ? 'Needed by'
        : isService
            ? 'Availability'
            : 'Available';
    final IconData icon =
        product['icon'] ?? Icons.shopping_bag_outlined;
    final String heroTag = 'product-image-$name';

    return Scaffold(
      backgroundColor: const Color(0xFF000000),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ==================================================
            // TOP BAR
            // ==================================================

            SliverToBoxAdapter(
              child: _buildTopBar(context),
            ),

            // ==================================================
            // PRODUCT IMAGE
            // ==================================================

            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProductImage(
                    icon,
                    categoryLabel,
                    heroTag,
                  ),
                  if (_videoInitialized && _videoController != null) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_videoController!),
                            PlayPauseOverlay(controller: _videoController!),
                            VideoProgressIndicator(_videoController!, allowScrubbing: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ==================================================
            // PRODUCT INFORMATION
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  0,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF166534),
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                      child: Text(
                        badgeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Listing title
                    Text(
                      isSaleRequest
                          ? 'Looking for: $name'
                          : isService
                              ? name
                              : name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF22C55E),
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Price
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          priceLabel,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (unit.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 3,
                            ),
                            child: Text(
                              unit,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 9),

                    Text(
                      '$availabilityLabel: $available',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFACC15),
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$rating ($reviews reviews)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // SELLER
            // ==================================================

            SliverToBoxAdapter(
              child: _buildSellerCard(
                context,
                seller,
                location,
              ),
            ),

            // ==================================================
            // DESCRIPTION
            // ==================================================

            SliverToBoxAdapter(
              child: _buildDescription(
                name,
                seller,
                location,
              ),
            ),

            // ==================================================
            // ACTION BUTTONS
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  25,
                  20,
                  30,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          size: 19,
                        ),
                        label: const Text(
                          'Message',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              const Color(0xFF22C55E),
                          side: const BorderSide(
                            color: Color(0xFF22C55E),
                          ),
                          minimumSize:
                              const Size(0, 52),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 19,
                        ),
                        label: const Text(
                          'Add to Cart',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF22C55E),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          minimumSize:
                              const Size(0, 52),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10,
        7,
        10,
        7,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 21,
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 25,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRODUCT IMAGE
  // ==========================================================

  Widget _buildProductImage(
    IconData icon,
    String category,
    String heroTag,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF16351F),
            Color(0xFF0B1C12),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.07,
          ),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Hero(
              tag: heroTag,
              child: Icon(
                icon,
                color: const Color(0xFF22C55E),
                size: 105,
              ),
            ),
          ),

          Positioned(
            left: 15,
            bottom: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.65,
                ),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SELLER CARD
  // ==========================================================

  Widget _buildSellerCard(
    BuildContext context,
    String seller,
    String location,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          NexifyTransitions.fadeSlide(
            SellerProfileScreen(product: widget.product),
            horizontal: true,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          20,
          25,
          20,
          0,
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.07,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: Color(0xFF18231C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white70,
                size: 29,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          seller,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      const Icon(
                        Icons.verified,
                        color:
                            Color(0xFF22C55E),
                        size: 16,
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Verified seller • $location',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DESCRIPTION
  // ==========================================================

  Widget _buildDescription(
    String name,
    String seller,
    String location,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'About this product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$name is currently listed by $seller '
            'in $location. Contact the seller through '
            'Nexify to confirm availability, pricing, '
            'delivery options and other product details.',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}