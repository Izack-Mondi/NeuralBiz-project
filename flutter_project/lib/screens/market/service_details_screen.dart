import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/auth_controller.dart';
import '../../data/connection_request_repository.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key, required this.service});

  final Map<String, dynamic> service;

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();

  bool _isSending = false;
  bool _hasResponded = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _hydrateResponseState();
  }

  Future<void> _hydrateResponseState() async {
    final recipientUserId =
        (widget.service['sellerId'] ?? widget.service['ownerId'] ?? '')
            .toString();
    final listingId =
        (widget.service['listingId'] ?? widget.service['id'] ?? '').toString();
    final currentUserId = context.read<AuthController>().currentUserId ?? '';

    if (recipientUserId.isEmpty || listingId.isEmpty) {
      return;
    }

    final repository = context.read<ConnectionRequestRepository>();
    final request = await repository.findRequestForListing(
      requesterUserId: currentUserId,
      recipientUserId: recipientUserId,
      listingId: listingId,
    );

    if (!mounted || request == null) {
      return;
    }

    setState(() {
      _hasResponded = true;
      _isConnected = request.isAccepted;
    });
  }

  Future<void> _handleRespond() async {
    final recipientUserId =
        (widget.service['sellerId'] ?? widget.service['ownerId'] ?? '')
            .toString();
    final listingId =
        (widget.service['listingId'] ?? widget.service['id'] ?? '').toString();
    final serviceTitle = (widget.service['name'] ?? 'Service').toString();
    final providerName = (widget.service['seller'] ?? 'Service provider')
        .toString();
    final currentUserId = context.read<AuthController>().currentUserId ?? '';

    if (recipientUserId.isEmpty || listingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This service does not have a valid provider profile.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isSending) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final incomingMessage = _messageController.text.trim();
      final request = await context
          .read<ConnectionRequestRepository>()
          .sendConnectionRequest(
            requesterUserId: currentUserId,
            recipientUserId: recipientUserId,
            listingId: listingId,
            listingOwnerId: recipientUserId,
            listingName: serviceTitle,
            recipientName: providerName,
            serviceTitle: serviceTitle,
            message: incomingMessage.isEmpty
                ? 'Hi, I am interested in your $serviceTitle.'
                : incomingMessage,
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSending = false;
        _hasResponded = true;
        _isConnected = request?.isAccepted ?? false;
      });

      final snackText = request?.isAccepted ?? false
          ? 'Conversation started with $providerName.'
          : 'Response sent to $providerName for $serviceTitle.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackText),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2563EB),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to send the response. Please try again.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    final String serviceName = (service['name'] ?? 'Service').toString();
    final String providerName = (service['seller'] ?? 'Service provider')
        .toString();
    final String location = (service['location'] ?? 'Location unavailable')
        .toString();
    final String category =
        (service['serviceCategory'] ??
                service['displayCategory'] ??
                service['category'] ??
                'SERVICE')
            .toString()
            .toUpperCase();
    final String price =
        (service['rate'] ?? service['price'] ?? 'Contact for pricing')
            .toString();
    final String availability =
        (service['available'] ?? service['availabilityText'] ?? 'Available')
            .toString();
    final String rating = (service['rating'] ?? '4.8').toString();
    final String reviews = (service['reviews'] ?? '0').toString();
    final String description =
        (service['description'] ??
                'Professional service tailored to your client needs.')
            .toString();
    final String imagePath = (service['imagePath'] ?? '').toString();
    final IconData serviceIcon = service['icon'] is IconData
        ? service['icon'] as IconData
        : Icons.handyman_outlined;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF112E1F), Color(0xFF08150E)],
                  ),
                ),
                child: imagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, _, _) => Center(
                            child: Icon(
                              serviceIcon,
                              color: const Color(0xFF22C55E),
                              size: 64,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          serviceIcon,
                          color: const Color(0xFF22C55E),
                          size: 64,
                        ),
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF166534),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      serviceName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF22C55E),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
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
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Availability: $availability',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFACC15),
                          size: 17,
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
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0F1C),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFF18231C),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          providerName
                              .split(RegExp(r'\s+'))
                              .take(2)
                              .map((part) => part.substring(0, 1).toUpperCase())
                              .join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  providerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF22C55E),
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Verified service provider',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About this service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Initial message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      minLines: 3,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0F1C),
                        hintText: 'Hi, I need ...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: const Color(0xFF22C55E)
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSending || _isConnected
                        ? null
                        : _handleRespond,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConnected
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF1D4ED8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isSending
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Sending...'),
                            ],
                          )
                        : Text(
                            _isConnected
                                ? 'Conversation Started'
                                : _hasResponded
                                ? 'Response Sent'
                                : 'Respond to Service',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
