import 'package:flutter/material.dart';

import '../../models/sale_request.dart';
import '../../widgets/nexify_transitions.dart';
import 'offer_service_screen.dart';
import 'post_product_screen.dart';
import 'request_a_product_screen.dart';

class _ListingOptionData {
  const _ListingOptionData({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
}

class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ListingOptionData> listingOptions = [
      _ListingOptionData(
        icon: Icons.shopping_bag_outlined,
        title: 'Post a Product',
        description: 'Sell agricultural or business products.',
        onTap: () {
          Navigator.push(
            context,
            NexifyTransitions.fadeSlide(
              const PostProductScreen(),
              horizontal: true,
            ),
          );
        },
      ),
      _ListingOptionData(
        icon: Icons.assignment_outlined,
        title: 'Make a Sale Request',
        description: 'Tell nearby sellers what you need to buy.',
        onTap: () {
          Navigator.push(
            context,
            NexifyTransitions.fadeSlide(
              const RequestAProductScreen(),
              horizontal: true,
            ),
          ).then((value) {
            if (value is Map<String, dynamic> && context.mounted) {
              Navigator.of(context).pop(value);
            }
            if (value is SaleRequest && context.mounted) {
              Navigator.of(context).pop(value);
            }
          });
        },
      ),
      _ListingOptionData(
        icon: Icons.handyman_outlined,
        title: 'Offer a Service',
        description: 'Offer your skills or professional services.',
        onTap: () {
          Navigator.push(
            context,
            NexifyTransitions.fadeSlide(
              const OfferServiceScreen(),
              horizontal: true,
            ),
          ).then((value) {
            if (value is Map<String, dynamic> && context.mounted) {
              Navigator.of(context).pop(value);
            }
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 21,
          ),
        ),
        title: const Text(
          'Create Listing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            15,
            20,
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // INTRO
              // ==================================================

              const Text(
                'What do you want to post?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Choose what you want to offer or request on Nexify.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 25),

              ...List.generate(listingOptions.length, (index) {
                final option = listingOptions[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == listingOptions.length - 1 ? 0 : 13,
                  ),
                  child: _listingOption(
                    context: context,
                    icon: option.icon,
                    title: option.title,
                    description: option.description,
                    onTap: option.onTap,
                  ),
                );
              }),

              const SizedBox(height: 28),

              // ==================================================
              // INFORMATION CARD
              // ==================================================

              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF07150D),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF22C55E)
                        .withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E)
                            .withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFF22C55E),
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 13),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Build trust with complete listings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            'Add accurate prices, locations, '
                            'availability and descriptions so '
                            'buyers can make better decisions.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ],
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

  // ============================================================
  // LISTING OPTION
  // ============================================================

  Widget _listingOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF16351F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF22C55E),
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      height: 1.4,
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

}
