import 'dart:io';

import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onRespond,
    required this.isPending,
    required this.isConnected,
    required this.isSending,
  });

  final Map<String, dynamic> service;
  final VoidCallback onTap;
  final VoidCallback onRespond;
  final bool isPending;
  final bool isConnected;
  final bool isSending;

  String get _serviceCategory =>
      (service['serviceCategory'] ?? service['displayCategory'] ?? service['category'] ?? 'SERVICE')
          .toString()
          .toUpperCase();

  String get _pricing =>
      (service['rate'] ?? service['price'] ?? 'Contact for pricing').toString();

  String get _availability =>
      (service['available'] ?? service['availabilityText'] ?? 'Available').toString();

  String get _description =>
      (service['description'] ?? 'Professional service tailored to your needs.').toString();

  IconData get _serviceIcon =>
      (service['icon'] is IconData) ? service['icon'] as IconData : Icons.handyman_outlined;

  bool get _hasImage =>
      service['imagePath'] != null && service['imagePath'].toString().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final providerName = (service['seller'] ?? 'Service provider').toString();
    final providerInitials = providerName.split(RegExp(r'\s+')).take(2).map((part) => part.substring(0, 1).toUpperCase()).join();
    final providerBadge = service['verified'] == true ? Icons.verified : Icons.verified_outlined;

    return GestureDetector(
      onTap: onTap,
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
                Container(
                  height: 136,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF112E1F), Color(0xFF08150E)],
                    ),
                  ),
                  child: _hasImage
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: Image.file(
                            File(service['imagePath'].toString()),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, _, _) => _placeholderIcon(),
                          ),
                        )
                      : _placeholderIcon(),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF166534),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      _serviceCategory,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
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
                        child: Center(
                          child: Text(
                            providerInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          providerName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        providerBadge,
                        color: const Color(0xFF22C55E),
                        size: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    (service['location'] ?? 'Location unavailable').toString(),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (service['name'] ?? 'Service').toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pricing,
                    style: const TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Availability: $_availability',
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
                        '${service['rating'] ?? '4.8'} (${service['reviews'] ?? '0'} reviews)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: (isPending || isConnected || isSending) ? null : onRespond,
                    child: Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isConnected
                            ? const Color(0xFF16A34A)
                            : isPending || isSending
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
                                    ? 'Conversation Started'
                                    : isPending
                                        ? 'Response Sent'
                                        : 'Respond to Service',
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
    );
  }

  Widget _placeholderIcon() {
    return Center(
      child: Icon(
        _serviceIcon,
        color: const Color(0xFF22C55E),
        size: 58,
      ),
    );
  }
}
