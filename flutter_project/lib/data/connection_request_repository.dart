import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/connection_request.dart';

class ConnectionRequestRepository extends ChangeNotifier {
  static const String _boxName = 'connection_requests';
  static const String _requestsKey = 'requests';
  List<ConnectionRequest> _requests = <ConnectionRequest>[];

  List<ConnectionRequest> get requests => List.unmodifiable(_requests);

  Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  Future<List<ConnectionRequest>> loadRequests() async {
    final box = await _box();
    final raw = box.get(_requestsKey, defaultValue: <dynamic>[]);

    if (raw is! List) {
      return <ConnectionRequest>[];
    }

    _requests = raw
        .whereType<Map>()
        .map(
          (entry) =>
              ConnectionRequest.fromJson(Map<String, dynamic>.from(entry)),
        )
        .toList();
    notifyListeners();
    return List<ConnectionRequest>.from(_requests);
  }

  Future<void> saveRequests(List<ConnectionRequest> requests) async {
    final box = await _box();
    await box.put(
      _requestsKey,
      requests.map((request) => request.toJson()).toList(),
    );
    _requests = List<ConnectionRequest>.from(requests);
    notifyListeners();
  }

  Future<ConnectionRequest?> sendConnectionRequest({
    required String requesterUserId,
    required String recipientUserId,
    required String listingId,
    required String listingOwnerId,
    required String listingName,
    required String recipientName,
    String message = '',
    String serviceTitle = '',
  }) async {
    if (requesterUserId.isEmpty ||
        recipientUserId.isEmpty ||
        listingId.isEmpty) {
      throw ArgumentError(
        'Requester, recipient and listing identifiers are required.',
      );
    }

    final requests = await loadRequests();
    final existingRequest = requests.firstWhere(
      (request) =>
          request.requesterUserId == requesterUserId &&
          request.recipientUserId == recipientUserId &&
          request.listingId == listingId &&
          !request.isDeclined,
      orElse: () => ConnectionRequest.empty(),
    );

    if (existingRequest.id.isNotEmpty) {
      return existingRequest;
    }

    final newRequest = ConnectionRequest(
      id: 'req_${DateTime.now().microsecondsSinceEpoch}',
      requesterUserId: requesterUserId,
      recipientUserId: recipientUserId,
      listingId: listingId,
      listingOwnerId: listingOwnerId,
      listingName: listingName,
      recipientName: recipientName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: ConnectionRequestStatus.pending.name,
      message: message,
      serviceTitle: serviceTitle.isNotEmpty ? serviceTitle : listingName,
    );

    requests.insert(0, newRequest);
    await saveRequests(requests);
    return newRequest;
  }

  Future<ConnectionRequest?> findRequestForListing({
    required String requesterUserId,
    required String recipientUserId,
    required String listingId,
  }) async {
    final requests = await loadRequests();

    for (final request in requests) {
      if (request.requesterUserId == requesterUserId &&
          request.recipientUserId == recipientUserId &&
          request.listingId == listingId) {
        return request;
      }
    }

    return null;
  }

  Future<void> markRequestAccepted({required String requestId}) async {
    final requests = await loadRequests();
    final updatedRequests = requests.map((request) {
      if (request.id == requestId) {
        return ConnectionRequest(
          id: request.id,
          requesterUserId: request.requesterUserId,
          recipientUserId: request.recipientUserId,
          listingId: request.listingId,
          listingOwnerId: request.listingOwnerId,
          listingName: request.listingName,
          recipientName: request.recipientName,
          createdAt: request.createdAt,
          updatedAt: DateTime.now(),
          status: ConnectionRequestStatus.accepted.name,
          message: request.message,
          serviceTitle: request.serviceTitle,
        );
      }
      return request;
    }).toList();

    await saveRequests(updatedRequests);
  }
}
