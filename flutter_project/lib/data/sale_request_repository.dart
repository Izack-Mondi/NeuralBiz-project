import 'package:flutter/foundation.dart';

import '../models/sale_request.dart';

class SaleRequestRepository extends ChangeNotifier {
  List<SaleRequest> _requests = <SaleRequest>[];

  List<SaleRequest> get requests => List.unmodifiable(_requests);

  Future<List<SaleRequest>> loadRequests({String? search}) async {
    await Future.delayed(const Duration(milliseconds: 350));

    // TODO: replace with NestJS API call
    final requests = <SaleRequest>[
      SaleRequest(
        id: 'sr_1',
        title: '50kg Grade 1 Maize',
        category: 'Farm Produce',
        quantity: '50 kg',
        budget: 'KSh 4,500',
        location: 'Nairobi, Kenya',
        neededBy: '30 Aug 2025',
        description: 'I need 50kg of Grade 1 maize for my poultry business.',
        requesterName: 'Brian Otieno',
        requesterId: 'u_brian',
        status: SaleRequestStatus.open,
        urgency: SaleRequestUrgency.urgent,
        imagePath: null,
        notes: 'Looking for clean, dry stock.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        connectionCount: 2,
      ),
      SaleRequest(
        id: 'sr_2',
        title: '100 Broiler Chicken',
        category: 'Poultry',
        quantity: '100 birds',
        budget: 'KSh 7,000',
        location: 'Kiambu, Kenya',
        neededBy: '28 Aug 2025',
        description: 'Looking for day-old broiler chicks for my farm.',
        requesterName: 'Mary Wanjiku',
        requesterId: 'u_mary',
        status: SaleRequestStatus.open,
        urgency: SaleRequestUrgency.standard,
        imagePath: null,
        notes: 'Chicks available within 7 days.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        connectionCount: 1,
      ),
      SaleRequest(
        id: 'sr_3',
        title: 'Tomatoes',
        category: 'Farm Produce',
        quantity: '20 crates',
        budget: 'KSh 3,000',
        location: 'Machakos, Kenya',
        neededBy: '30 Aug 2025',
        description: 'Fresh tomatoes needed for my grocery business.',
        requesterName: 'James Mwangi',
        requesterId: 'u_james',
        status: SaleRequestStatus.open,
        urgency: SaleRequestUrgency.standard,
        imagePath: null,
        notes: 'Prefer firm red tomatoes.',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        connectionCount: 3,
      ),
    ];

    final normalizedQuery = (search ?? '').trim().toLowerCase();
    _requests = normalizedQuery.isEmpty
        ? requests
        : requests.where((request) {
            final haystack = [
              request.title,
              request.category,
              request.location,
              request.requesterName,
            ].join(' ').toLowerCase();
            return haystack.contains(normalizedQuery);
          }).toList();
    notifyListeners();
    return requests;
  }

  void addRequest(SaleRequest request) {
    _requests = [request, ..._requests];
    notifyListeners();
  }
}
