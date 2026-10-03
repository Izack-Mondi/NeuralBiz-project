import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/auth_controller.dart';
import '../../models/product.dart';
import '../../widgets/feedback/nexify_empty_state.dart';
import '../../widgets/feedback/nexify_error_state.dart';
import '../../widgets/feedback/nexify_loading.dart';
import '../../widgets/feedback/nexify_shimmer.dart';
import '../../widgets/nexify_collapsing_scroll_view.dart';
import '../../widgets/nexify_transitions.dart';
import '../../widgets/service_card.dart';
import '../../data/connection_request_repository.dart';
import '../../data/local_storage.dart';
import 'create_listing_screen.dart';
import 'product_details_screen.dart';
import 'requests_screen.dart';
import 'service_details_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int selectedSector = 0;
  int selectedCategory = 0;
  final Set<String> _favoritedProducts = <String>{};
  final Set<String> _connectedProducts = <String>{};
  final Set<String> _pendingConnectionRequestIds = <String>{};
  final Set<String> _sendingConnectionRequestIds = <String>{};
  bool _isLoading = true;
  bool _hasLoadError = false;

  final List<String> sectors = ['All', 'Agriculture', 'Business'];

  final List<Map<String, dynamic>> categories = [
    {'title': 'Products', 'icon': Icons.shopping_bag_outlined},
    {'title': 'Services', 'icon': Icons.handyman_outlined},
    {'title': 'Requests', 'icon': Icons.assignment_outlined},
    {'title': 'Nearby', 'icon': Icons.location_on_outlined},
    {'title': 'Trending', 'icon': Icons.local_fire_department_outlined},
  ];

  List<Map<String, dynamic>> products = [
    {
      'listingId': 'listing_tomatoes',
      'sellerId': 'seller_farmer_john',
      'name': 'Fresh Tomatoes',
      'seller': 'Farmer John',
      'location': 'Kisumu, Kenya',
      'price': 'KSh 80',
      'unit': '/kg',
      'available': '500kg',
      'rating': '4.8',
      'reviews': '120',
      'category': 'AGRICULTURE',
      'icon': Icons.local_florist,
      'type': 'product',
    },
    {
      'listingId': 'listing_eggs',
      'sellerId': 'seller_agri_queen',
      'name': 'Farm Fresh Eggs',
      'seller': 'Agri Queen',
      'location': 'Nakuru, Kenya',
      'price': 'KSh 350',
      'unit': '/tray',
      'available': '200 trays',
      'rating': '4.9',
      'reviews': '98',
      'category': 'AGRICULTURE',
      'icon': Icons.egg_alt_outlined,
      'type': 'product',
    },
    {
      'listingId': 'listing_fertilizer',
      'sellerId': 'seller_green_grow',
      'name': 'DAP Fertilizer (50kg)',
      'seller': 'GreenGrow Supplies',
      'location': 'Eldoret, Kenya',
      'price': 'KSh 5,500',
      'unit': '',
      'available': '300 bags',
      'rating': '4.7',
      'reviews': '56',
      'category': 'AGRICULTURE',
      'icon': Icons.grass,
      'type': 'product',
    },
    {
      'listingId': 'listing_tractor',
      'sellerId': 'seller_tractor_hub',
      'name': 'John Deere 5075E',
      'seller': 'Tractor Hub',
      'location': 'Nairobi, Kenya',
      'price': 'KSh 2,450,000',
      'unit': '',
      'available': '2 units',
      'rating': '4.6',
      'reviews': '34',
      'category': 'AGRICULTURE',
      'icon': Icons.agriculture,
      'type': 'product',
    },
    {
      'listingId': 'listing_graphic_design',
      'sellerId': 'seller_john_mwangi',
      'name': 'Graphic Design Services',
      'seller': 'John Mwangi',
      'location': 'Nakuru, Kenya',
      'price': 'From KSh 1,500',
      'unit': '',
      'available': 'Available',
      'rating': '4.9',
      'reviews': '114',
      'category': 'TECHNOLOGY',
      'icon': Icons.design_services_outlined,
      'type': 'service',
      'serviceCategory': 'TECHNOLOGY',
      'displayCategory': 'TECHNOLOGY',
      'description': 'Professional posters, logos, social media graphics and branding materials.',
      'availabilityText': 'Available',
      'rate': 'From KSh 1,500',
    },
    {
      'listingId': 'listing_soil_testing',
      'sellerId': 'seller_agri_tech',
      'name': 'Farm Advisory & Soil Testing',
      'seller': 'AgriTech Solutions',
      'location': 'Eldoret, Kenya',
      'price': 'KSh 2,500/session',
      'unit': '',
      'available': 'Busy',
      'rating': '4.7',
      'reviews': '83',
      'category': 'AGRICULTURE',
      'icon': Icons.agriculture,
      'type': 'service',
      'serviceCategory': 'AGRICULTURE',
      'displayCategory': 'AGRICULTURE',
      'description': 'Crop planning, soil health checks, irrigation guidance and practical farm consultancy.',
      'availabilityText': 'Busy',
      'rate': 'KSh 2,500/session',
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    final activeSector = sectors[selectedSector];
    final activeCategory = categories[selectedCategory]['title'] as String;

    return products.where((product) {
      final text = [
        product['name'],
        product['seller'],
        product['category'],
        product['categoryName'],
        product['displayCategory'],
        product['customSpecialization'],
      ].join(' ').toString().toLowerCase();

      final matchesSector =
          activeSector == 'All' ||
          (activeSector == 'Agriculture' &&
              (text.contains('agriculture') ||
                  text.contains('farm') ||
                  text.contains('livestock') ||
                  text.contains('poultry') ||
                  text.contains('produce') ||
                  text.contains('maize') ||
                  text.contains('fertilizer') ||
                  text.contains('tractor') ||
                  text.contains('seed') ||
                  text.contains('tomato') ||
                  text.contains('egg'))) ||
          (activeSector == 'Business' &&
              (text.contains('business') ||
                  text.contains('advisory') ||
                  text.contains('inventory') ||
                  text.contains('management') ||
                  text.contains('consulting') ||
                  text.contains('supply') ||
                  text.contains('service')));

      if (!matchesSector) {
        return false;
      }

      switch (activeCategory) {
        case 'Products':
          return (product['type'] ?? '').toString() != 'service' &&
              (product['type'] ?? '').toString() != 'request';
        case 'Services':
          return (product['type'] ?? '').toString() == 'service';
        case 'Requests':
          return (product['type'] ?? '').toString() == 'request';
        case 'Nearby':
        case 'Trending':
          return true;
        default:
          return true;
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _initialiseMarketData();
  }

  Future<void> _initialiseMarketData() async {
    setState(() {
      _isLoading = true;
      _hasLoadError = false;
    });

    try {
      await _loadSavedListings();
      await _hydrateConnectionRequestState();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _hasLoadError = true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _retryLoad() async {
    await _initialiseMarketData();
  }

  Future<void> _hydrateConnectionRequestState() async {
    final currentUserId = context.read<AuthController>().currentUserId;
    try {
      final requests = await context
          .read<ConnectionRequestRepository>()
          .loadRequests();
      final pendingIds = <String>{};
      final connectedIds = <String>{};

      for (final request in requests) {
        if (request.requesterUserId != currentUserId) {
          continue;
        }

        final listingId = request.listingId.isEmpty
            ? request.listingName
            : request.listingId;

        if (request.isAccepted) {
          connectedIds.add(listingId);
        } else if (request.isPending) {
          pendingIds.add(listingId);
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _pendingConnectionRequestIds
          ..clear()
          ..addAll(pendingIds);
        _connectedProducts
          ..clear()
          ..addAll(connectedIds);
      });
    } catch (_) {
      // ignore hydration errors and fall back to the in-memory action state.
    }
  }

  String _listingIdFor(Map<String, dynamic> product) {
    final explicitId = product['listingId'] ?? product['id'];
    if (explicitId != null && explicitId.toString().isNotEmpty) {
      return explicitId.toString();
    }
    return (product['name'] ?? 'listing').toString();
  }

  Future<void> _loadSavedListings() async {
    try {
      final saved = await context.read<LocalStorage>().loadListings();
      if (saved.isNotEmpty) {
        setState(() {
          products = saved
              .map(_listingFromProduct)
              .toList()
              .followedBy(products)
              .toList();
        });
      }
    } catch (e) {
      // ignore load errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NexifyCollapsingScrollView(
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSearchBar(),
                    _buildSectorFilters(),
                    _buildCategoryBar(),
                  ],
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedCategory == 2)
                      const RequestsScreen(embedded: true)
                    else ...[
                      _buildFeaturedHeader(),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.67,
                            ),
                            itemBuilder: (context, index) => _buildSkeletonCard(),
                          ),
                        )
                      else if (_hasLoadError)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: NexifyErrorState(
                            title: 'Something went wrong',
                            message:
                                'We could not refresh the market listings.',
                            onRetry: _retryLoad,
                          ),
                        )
                      else if (filteredProducts.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: NexifyEmptyState(
                            title: 'No market listings yet',
                            message: 'Products, services and requests will appear here.',
                            icon: Icons.storefront_outlined,
                          ),
                        )
                      else
                        _buildProductGrid(),
                      _buildConfidenceCard(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // + BUTTON
      floatingActionButton: _buildCreateButton(),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
              ).createShader(bounds);
            },
            child: const Text(
              'Nexify',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),

          const Spacer(),

          const Text(
            'Market',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          // ==================================================
          // CART
          // ==================================================
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  // Cart screen will be connected later.
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              Positioned(
                right: 2,
                top: 1,
                child: Container(
                  width: 21,
                  height: 21,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ==================================================
          // NOTIFICATIONS
          // ==================================================
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  // Notifications screen will be connected later.
                },
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              Positioned(
                right: 8,
                top: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SEARCH BAR
  // ==========================================================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1C),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),

            const Icon(Icons.search, color: Colors.white70, size: 27),

            const SizedBox(width: 13),

            const Expanded(
              child: Text(
                'Search products, services, or sellers...',
                style: TextStyle(color: Colors.white54, fontSize: 15),
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tune, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTOR FILTERS
  // ==========================================================

  Widget _buildSectorFilters() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: sectors.length,
        itemBuilder: (context, index) {
          final selected = selectedSector == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSector = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF0A0F1C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF22C55E)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Center(
                child: Text(
                  sectors[index],
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // CATEGORY BAR
  // ==========================================================

  Widget _buildCategoryBar() {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF05070B),
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: SizedBox(
        height: 74,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final selected = selectedCategory == index;
            final item = categories[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = index;
                });
              },
              child: Container(
                width: 78,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      color: selected
                          ? const Color(0xFF22C55E)
                          : Colors.white60,
                      size: 28,
                    ),

                    const SizedBox(height: 7),

                    Text(
                      item['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF22C55E)
                            : Colors.white70,
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 7),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: selected ? 42 : 0,
                      color: const Color(0xFF22C55E),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // FEATURED HEADER
  // ==========================================================

  Widget _buildFeaturedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
      child: Row(
        children: [
          const Text(
            'Featured Listings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: () {},
            child: const Text(
              'View all',
              style: TextStyle(
                color: Color(0xFF22C55E),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRODUCT GRID
  // ==========================================================

  Widget _buildProductGrid() {
    final visibleProducts = filteredProducts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: visibleProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.67,
        ),
        itemBuilder: (context, index) {
          final listing = visibleProducts[index];
          if ((listing['type'] ?? '').toString() == 'service') {
            return ServiceCard(
              service: listing,
              onTap: () => _openListing(listing),
              onRespond: () => _handleServiceResponse(listing),
              isSending: _sendingConnectionRequestIds.contains(
                _listingIdFor(listing),
              ),
              isPending: _pendingConnectionRequestIds.contains(
                _listingIdFor(listing),
              ),
              isConnected: _connectedProducts.contains(_listingIdFor(listing)),
            );
          }
          return _buildProductCard(listing);
        },
      ),
    );
  }

  // ==========================================================
  // PRODUCT CARD
  // ==========================================================

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 135,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: const NexifyShimmer(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const NexifyShimmer(
                      width: 28,
                      height: 28,
                      borderRadius: 14,
                    ),
                    const SizedBox(width: 7),
                    const Expanded(
                      child: NexifyShimmer(
                        height: 11,
                        borderRadius: 4,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const NexifyShimmer(
                      width: 15,
                      height: 15,
                      borderRadius: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                const NexifyShimmer(
                  height: 10,
                  width: 80,
                  borderRadius: 4,
                ),
                const SizedBox(height: 8),
                const NexifyShimmer(
                  height: 14,
                  borderRadius: 4,
                ),
                const SizedBox(height: 6),
                const NexifyShimmer(
                  height: 15,
                  width: 60,
                  borderRadius: 4,
                ),
                const SizedBox(height: 6),
                const NexifyShimmer(
                  height: 10,
                  width: 100,
                  borderRadius: 4,
                ),
                const SizedBox(height: 9),
                const NexifyShimmer(
                  height: 10,
                  width: 50,
                  borderRadius: 4,
                ),
                const SizedBox(height: 9),
                const NexifyShimmer(
                  height: 32,
                  borderRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final listingId = _listingIdFor(product);
    final productId = listingId;
    final isFavorite = _favoritedProducts.contains(productId);
    final bool isPendingRequest = _pendingConnectionRequestIds.contains(
      productId,
    );
    final bool isConnected = _connectedProducts.contains(productId);
    final bool isSending = _sendingConnectionRequestIds.contains(productId);
    final String displayCategory =
        (product['type'] == 'service' &&
            (product['customSpecialization'] ?? '').toString().isNotEmpty)
        ? product['customSpecialization'].toString()
        : (product['type'] == 'request' &&
              (product['categoryName'] ?? '').toString().isNotEmpty)
        ? product['categoryName'].toString()
        : product['category']?.toString() ?? 'GENERAL';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          NexifyTransitions.fadeSlide(
            ProductDetailsScreen(product: product),
            horizontal: true,
          ),
        );
      },
      child: AnimatedScale(
        scale: 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F1C),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'product-image-$productId',
                    child: Container(
                      height: 135,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF16351F), Color(0xFF0B1C12)],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          product['icon'],
                          color: const Color(0xFF22C55E),
                          size: 58,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isFavorite) {
                            _favoritedProducts.remove(productId);
                          } else {
                            _favoritedProducts.add(productId);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFavorite
                                ? const Color(0xFF22C55E)
                                : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeInCubic,
                          child: Icon(
                            key: ValueKey<bool>(isFavorite),
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? const Color(0xFF22C55E)
                                : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF166534),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        displayCategory,
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

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF18231C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 17,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            product['seller'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF22C55E),
                          size: 15,
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      product['location'],
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: product['price'],
                            style: const TextStyle(
                              color: Color(0xFF22C55E),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: ' ${product['unit']}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Available: ${product['available']}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFACC15),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product['rating']} (${product['reviews']})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    GestureDetector(
                      onTap: (isPendingRequest || isConnected || isSending)
                          ? null
                          : () => _handleConnect(product),
                      child: Container(
                        width: double.infinity,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isConnected
                              ? const Color(0xFF16A34A)
                              : isPendingRequest || isSending
                              ? const Color(0xFF1D4ED8)
                              : const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isConnected
                                ? const Color(0xFF4ADE80).withValues(alpha: 0.7)
                                : Colors.transparent,
                          ),
                        ),
                        child: Center(
                          child: isSending
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Sending...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  isConnected
                                      ? 'Connected'
                                      : isPendingRequest
                                      ? 'Request Sent'
                                      : 'Connect',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openListing(Map<String, dynamic> listing) {
    final type = (listing['type'] ?? 'product').toString();
    final screen = type == 'service'
        ? ServiceDetailsScreen(service: listing)
        : ProductDetailsScreen(product: listing);

    Navigator.push(
      context,
      NexifyTransitions.fadeSlide(screen, horizontal: true),
    );
  }

  Future<void> _handleServiceResponse(Map<String, dynamic> service) async {
    final listingId = _listingIdFor(service);
    final seller = (service['seller'] ?? 'service provider').toString();
    final recipientUserId = (service['sellerId'] ?? service['ownerId'] ?? '')
        .toString();
    final serviceTitle = (service['name'] ?? 'Service').toString();
    final currentUserId = context.read<AuthController>().currentUserId ?? '';

    if (recipientUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This service does not have a valid provider profile.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_sendingConnectionRequestIds.contains(listingId)) {
      return;
    }

    setState(() {
      _sendingConnectionRequestIds.add(listingId);
    });

    try {
      final request = await context
          .read<ConnectionRequestRepository>()
          .sendConnectionRequest(
            requesterUserId: currentUserId,
            recipientUserId: recipientUserId,
            listingId: listingId,
            listingOwnerId: recipientUserId,
            listingName: serviceTitle,
            recipientName: seller,
            serviceTitle: serviceTitle,
            message: 'Hi, I am interested in your $serviceTitle.',
          );

      if (!mounted) {
        return;
      }

      final bool isAccepted = request?.isAccepted ?? false;
      final bool isPending = request?.isPending ?? false;

      setState(() {
        _sendingConnectionRequestIds.remove(listingId);

        if (isAccepted) {
          _connectedProducts.add(listingId);
          _pendingConnectionRequestIds.remove(listingId);
        } else {
          _connectedProducts.remove(listingId);
          _pendingConnectionRequestIds.add(listingId);
        }
      });

      final message = isAccepted
          ? 'Connected with $seller for $serviceTitle.'
          : isPending
          ? 'Response sent to $seller for $serviceTitle.'
          : 'You already responded to $seller for $serviceTitle.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2563EB),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _sendingConnectionRequestIds.remove(listingId);
        _pendingConnectionRequestIds.remove(listingId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to send the service response. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _handleConnect(Map<String, dynamic> product) async {
    final listingId = _listingIdFor(product);
    final seller = (product['seller'] ?? 'seller').toString();
    final recipientUserId = (product['sellerId'] ?? product['ownerId'] ?? '')
        .toString();
    final currentUserId = context.read<AuthController>().currentUserId ?? '';

    if (recipientUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This listing does not have a valid seller profile.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_sendingConnectionRequestIds.contains(listingId)) {
      return;
    }

    setState(() {
      _sendingConnectionRequestIds.add(listingId);
    });

    try {
      final request = await context
          .read<ConnectionRequestRepository>()
          .sendConnectionRequest(
            requesterUserId: currentUserId,
            recipientUserId: recipientUserId,
            listingId: listingId,
            listingOwnerId: recipientUserId,
            listingName: (product['name'] ?? 'Listing').toString(),
            recipientName: seller,
          );

      if (!mounted) {
        return;
      }

      final bool isAccepted = request?.isAccepted ?? false;
      final bool isPending = request?.isPending ?? false;

      setState(() {
        _sendingConnectionRequestIds.remove(listingId);

        if (isAccepted) {
          _connectedProducts.add(listingId);
          _pendingConnectionRequestIds.remove(listingId);
        } else {
          _connectedProducts.remove(listingId);
          _pendingConnectionRequestIds.add(listingId);
        }
      });

      final message = isAccepted
          ? 'Connection accepted with $seller.'
          : isPending
          ? 'Connection request sent to $seller. It is pending approval.'
          : 'A connection request for $seller is already pending.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2563EB),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _sendingConnectionRequestIds.remove(listingId);
        _pendingConnectionRequestIds.remove(listingId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to send the connection request. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ==========================================================
  // CONFIDENCE CARD
  // ==========================================================

  Widget _buildConfidenceCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 22, 16, 10),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF07150D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF22C55E).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF22C55E),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buy with confidence',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Verified sellers. Safe payments.',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.white60),
        ],
      ),
    );
  }

  void _addListing(Map<String, dynamic> listing) {
    setState(() {
      products.insert(0, {
        'listingId':
            listing['listingId'] ??
            'listing_${(listing['name'] ?? 'new_listing').toString().replaceAll(RegExp(r'\s+'), '_').toLowerCase()}',
        'sellerId': listing['sellerId'] ?? 'seller_nexify_user',
        'name': listing['name'] ?? 'New listing',
        'seller': listing['seller'] ?? 'Nexify user',
        'location': listing['location'] ?? 'Kenya',
        'price': listing['price'] ?? 'Price negotiable',
        'unit': listing['unit'] ?? '',
        'available': listing['available'] ?? 'Available now',
        'rating': listing['rating'] ?? '4.8',
        'reviews': listing['reviews'] ?? '12',
        'category': listing['category'] ?? 'PRODUCT',
        'icon': listing['icon'] ?? Icons.shopping_bag_outlined,
        'type': listing['type'] ?? 'product',
        'customSpecialization': listing['customSpecialization'],
        'videoFilePath': listing['videoFilePath'],
        'videoLink': listing['videoLink'],
        'categoryName': listing['categoryName'],
      });
    });

    if ((products.first['type'] ?? 'product') == 'product') {
      final product = _productFromListing(products.first);
      context.read<LocalStorage>().addProduct(product);
    }
  }

  Product _productFromListing(Map<String, dynamic> listing) {
    final priceText = (listing['price'] ?? '0').toString();
    final numericPrice =
        double.tryParse(priceText.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    return Product(
      id: (listing['listingId'] ?? listing['id'] ?? '').toString(),
      name: (listing['name'] ?? 'Product').toString(),
      seller: (listing['seller'] ?? 'Nexify user').toString(),
      location: (listing['location'] ?? 'Kenya').toString(),
      price: numericPrice,
      unit: (listing['unit'] ?? '').toString(),
      availability: (listing['available'] ?? 'Available now').toString(),
      rating: double.tryParse((listing['rating'] ?? '0').toString()) ?? 0,
      reviews: int.tryParse((listing['reviews'] ?? '0').toString()) ?? 0,
      category: (listing['category'] ?? 'PRODUCT').toString(),
      imagePath: listing['imagePath']?.toString(),
    );
  }

  Map<String, dynamic> _listingFromProduct(Product product) {
    return {
      'listingId': product.id,
      'name': product.name,
      'seller': product.seller,
      'location': product.location,
      'price': 'KSh ${product.price}',
      'unit': product.unit,
      'available': product.availability,
      'rating': product.rating.toString(),
      'reviews': product.reviews.toString(),
      'category': product.category,
      'icon': Icons.shopping_bag_outlined,
      'type': 'product',
      'imagePath': product.imagePath,
    };
  }

  // ==========================================================
  // CREATE LISTING BUTTON
  // ==========================================================

  Widget _buildCreateButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          NexifyTransitions.modal(const CreateListingScreen()),
        ).then((value) {
          if (value is Map<String, dynamic>) {
            _addListing(value);
          }
        });
      },
      backgroundColor: const Color(0xFF22C55E),
      elevation: 8,
      child: const Icon(Icons.add, color: Colors.black, size: 31),
    );
  }
}
