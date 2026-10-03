import 'package:flutter/material.dart';

import '../../widgets/nexify_collapsing_scroll_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = ['All', 'Agriculture', 'Business', 'Nearby'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: NexifyCollapsingScrollView(
          header: Column(
            children: [_buildTopBar(), _buildFeedTabs(), _buildCategories()],
          ),
          content: _buildFeed(),
          fillRemaining: true,
        ),
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

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

  // ==========================================================
  // FOR YOU /
  // ==========================================================

  Widget _buildFeedTabs() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF17191D), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildFeedTab(title: 'For You', selected: true)],
      ),
    );
  }

  Widget _buildFeedTab({required String title, required bool selected}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF8A8C92),
            fontSize: 20,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),

        const SizedBox(height: 17),

        Container(
          width: selected ? 84 : 0,
          height: 2,
          color: const Color(0xFF22C55E),
        ),
      ],
    );
  }

  // ==========================================================
  // CATEGORY CHIPS
  // ==========================================================

  Widget _buildCategories() {
    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final selected = _selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index;
              });
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
                _categories[index],
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

  // ==========================================================
  // FEED
  // ==========================================================

  Widget _buildFeed() {
    return PageView(
      scrollDirection: Axis.vertical,
      children: [
        _buildPost(
          imagePath: 'assets/images/farmer.png',
          creatorName: 'Grace Wanjiku',
          creatorDescription: 'Vegetable Farmer • Kiambu, Kenya',
          category: 'Fresh Produce',
          caption:
              'Fresh sukuma wiki straight from my farm!\n'
              'Eat healthy, live healthy',
          likes: '8.4K',
          comments: '342',
          shares: '1.2K',
          hashtags: ['#FarmingLife', '#HealthyLiving', '#SupportLocal'],
          sound: 'Original sound - Grace Wanjiku',
        ),

        _buildPost(
          imagePath: 'assets/images/business.png',
          creatorName: 'Nexify Business',
          creatorDescription: 'Small Business • Nairobi, Kenya',
          category: 'Business',
          caption:
              'Discover new opportunities and connect '
              'with businesses around you.',
          likes: '5.7K',
          comments: '218',
          shares: '892',
          hashtags: ['#Business', '#Nexify', '#Opportunities'],
          sound: 'Original sound - Nexify Business',
        ),
      ],
    );
  }

  // ==========================================================
  // POST
  // ==========================================================

  Widget _buildPost({
    required String imagePath,
    required String creatorName,
    required String creatorDescription,
    required String category,
    required String caption,
    required String likes,
    required String comments,
    required String shares,
    required List<String> hashtags,
    required String sound,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // POST IMAGE
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF0A0F1C),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Color(0xFF22C55E),
                  size: 70,
                ),
              ),
            );
          },
        ),

        // DARK GRADIENT
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.35, 0.72, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.90),
                ],
              ),
            ),
          ),
        ),

        // CATEGORY
        Positioned(
          left: 34,
          bottom: 365,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.eco_outlined,
                  color: Color(0xFF22C55E),
                  size: 19,
                ),

                const SizedBox(width: 7),

                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // CREATOR + CAPTION
        Positioned(
          left: 34,
          right: 120,
          bottom: 72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    creatorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 7),

                  const Icon(
                    Icons.verified,
                    color: Color(0xFF22C55E),
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                creatorDescription,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),

              const SizedBox(height: 16),

              Text(
                caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 13),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: hashtags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 22),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      sound,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ACTIONS
        Positioned(
          right: 25,
          bottom: 125,
          child: Column(
            children: [
              _buildProfileAction(),

              const SizedBox(height: 22),

              _buildAction(icon: Icons.favorite, value: likes),

              const SizedBox(height: 22),

              _buildAction(icon: Icons.chat_bubble, value: comments),

              const SizedBox(height: 22),

              _buildAction(icon: Icons.send, value: shares),

              const SizedBox(height: 22),

              _buildAction(icon: Icons.more_horiz, value: ''),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PROFILE ACTION
  // ==========================================================

  Widget _buildProfileAction() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF22C55E), width: 2),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF0A0F1C),
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
            ),

            Positioned(
              bottom: -9,
              left: 17,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),

        const SizedBox(height: 17),
      ],
    );
  }

  // ==========================================================
  // ACTION BUTTON
  // ==========================================================

  Widget _buildAction({required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 40),

        if (value.isNotEmpty) ...[
          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
