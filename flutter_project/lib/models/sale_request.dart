import 'package:flutter/material.dart';

enum SaleRequestStatus { open, fulfilled, expired }
enum SaleRequestUrgency { urgent, standard, flexible }

class SaleRequest {
  const SaleRequest({
    required this.id,
    required this.title,
    required this.category,
    required this.quantity,
    required this.budget,
    required this.location,
    required this.neededBy,
    required this.description,
    required this.requesterName,
    required this.requesterId,
    required this.status,
    required this.urgency,
    this.imagePath,
    this.notes,
    required this.createdAt,
    required this.connectionCount,
  });

  final String id;
  final String title;
  final String category;
  final String quantity;
  final String budget;
  final String location;
  final String neededBy;
  final String description;
  final String requesterName;
  final String requesterId;
  final SaleRequestStatus status;
  final SaleRequestUrgency urgency;
  final String? imagePath;
  final String? notes;
  final DateTime createdAt;
  final int connectionCount;

  factory SaleRequest.fromJson(Map<String, dynamic> json) {
    return SaleRequest(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Sale request',
      category: json['category'] as String? ?? 'General',
      quantity: json['quantity'] as String? ?? 'Flexible',
      budget: json['budget'] as String? ?? 'Price flexible',
      location: json['location'] as String? ?? 'Kenya',
      neededBy: json['neededBy'] as String? ?? 'Flexible',
      description: json['description'] as String? ?? 'Looking for this item.',
      requesterName: json['requesterName'] as String? ?? 'Buyer',
      requesterId: json['requesterId'] as String? ?? 'buyer',
      status: SaleRequestStatus.values.firstWhere(
        (value) => value.name == (json['status'] as String? ?? 'open'),
        orElse: () => SaleRequestStatus.open,
      ),
      urgency: SaleRequestUrgency.values.firstWhere(
        (value) => value.name == (json['urgency'] as String? ?? 'standard'),
        orElse: () => SaleRequestUrgency.standard,
      ),
      imagePath: json['imagePath'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      connectionCount: (json['connectionCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'quantity': quantity,
      'budget': budget,
      'location': location,
      'neededBy': neededBy,
      'description': description,
      'requesterName': requesterName,
      'requesterId': requesterId,
      'status': status.name,
      'urgency': urgency.name,
      'imagePath': imagePath,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'connectionCount': connectionCount,
    };
  }

  Map<String, dynamic> toLegacyMap() {
    return {
      'name': title,
      'seller': requesterName,
      'location': location,
      'price': budget,
      'unit': quantity,
      'available': neededBy,
      'rating': '4.9',
      'reviews': connectionCount.toString(),
      'category': 'REQUEST PRODUCT',
      'icon': Icons.assignment_outlined,
      'type': 'request',
      'description': description,
      'categoryName': category,
      'neededBy': neededBy,
      'budget': budget,
      'quantityNeeded': quantity,
      'customSpecialization': category,
    };
  }
}
