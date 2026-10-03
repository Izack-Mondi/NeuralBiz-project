import 'package:flutter/material.dart';

class SellerProfileScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const SellerProfileScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final seller = product['seller'] ?? 'Seller';
    final location = product['location'] ?? 'Location unavailable';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(
                      seller,
                      location,
                    ),

                    _buildSellerStats(),

                    _buildAboutSection(
                      seller,
                      location,
                    ),

                    _buildProductsSection(),

                    const SizedBox(height: 30),
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
        8,
        10,
        8,
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
              size: 22,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Seller Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROFILE HEADER
  // ==========================================================

  Widget _buildProfileHeader(
    String seller,
    String location,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF22C55E),
                  width: 2,
                ),
                color: const Color(0xFF18231C),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 55,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  seller,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              const Icon(
                Icons.verified,
                color: Color(0xFF22C55E),
                size: 21,
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF22C55E),
                size: 17,
              ),

              const SizedBox(width: 4),

              Text(
                location,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'Verified Nexify Seller',
            style: TextStyle(
              color: Color(0xFF22C55E),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF22C55E),
                    side: const BorderSide(
                      color: Color(0xFF22C55E),
                    ),
                    minimumSize: const Size(
                      0,
                      48,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF22C55E),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(
                      0,
                      48,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
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

  // ==========================================================
  // SELLER STATS
  // ==========================================================

  Widget _buildSellerStats() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1C),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.07,
          ),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _StatItem(
              value: '24',
              label: 'Listings',
            ),
          ),
          Expanded(
            child: _StatItem(
              value: '4.8',
              label: 'Rating',
            ),
          ),
          Expanded(
            child: _StatItem(
              value: '120',
              label: 'Reviews',
            ),
          ),
          Expanded(
            child: _StatItem(
              value: '96%',
              label: 'Response',
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ABOUT
  // ==========================================================

  Widget _buildAboutSection(
    String seller,
    String location,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            '$seller is a verified Nexify seller based in '
            '$location. This seller can connect with buyers '
            'through Nexify and provide products, pricing, '
            'availability and delivery information.',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRODUCTS
  // ==========================================================

  Widget _buildProductsSection() {
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
          Row(
            children: [
              const Text(
                'Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              const Text(
                'View all',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _buildProductPreview(
            'Current Listing',
            product['price'] ?? 'Price unavailable',
            product['unit'] ?? '',
          ),

          const SizedBox(height: 10),

          _buildProductPreview(
            'More products from this seller',
            'View seller listings',
            '',
          ),
        ],
      ),
    );
  }

  Widget _buildProductPreview(
    String title,
    String price,
    String unit,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1C),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.07,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF16351F),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFF22C55E),
              size: 29,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  unit.isNotEmpty
                      ? '$price $unit'
                      : price,
                  style: const TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// STAT ITEM
// ==========================================================

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}