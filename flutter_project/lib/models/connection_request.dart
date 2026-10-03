enum ConnectionRequestStatus {
  pending,
  accepted,
  declined,
}

class ConnectionRequest {
  ConnectionRequest({
    required this.id,
    required this.requesterUserId,
    required this.recipientUserId,
    required this.listingId,
    required this.listingOwnerId,
    required this.listingName,
    required this.recipientName,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.message = '',
    this.serviceTitle = '',
  });

  ConnectionRequest.empty()
      : id = '',
        requesterUserId = '',
        recipientUserId = '',
        listingId = '',
        listingOwnerId = '',
        listingName = '',
        recipientName = '',
        createdAt = null,
        updatedAt = null,
        status = ConnectionRequestStatus.pending.name,
        message = '',
        serviceTitle = '';

  final String id;
  final String requesterUserId;
  final String recipientUserId;
  final String listingId;
  final String listingOwnerId;
  final String listingName;
  final String recipientName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String status;
  final String message;
  final String serviceTitle;

  ConnectionRequestStatus get statusEnum =>
      ConnectionRequestStatus.values.firstWhere(
        (item) => item.name == status,
        orElse: () => ConnectionRequestStatus.pending,
      );

  bool get isPending => statusEnum == ConnectionRequestStatus.pending;
  bool get isAccepted => statusEnum == ConnectionRequestStatus.accepted;
  bool get isDeclined => statusEnum == ConnectionRequestStatus.declined;

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString() ?? ConnectionRequestStatus.pending.name;
    return ConnectionRequest(
      id: json['id']?.toString() ?? '',
      requesterUserId: json['requesterUserId']?.toString() ?? '',
      recipientUserId: json['recipientUserId']?.toString() ?? '',
      listingId: json['listingId']?.toString() ?? '',
      listingOwnerId: json['listingOwnerId']?.toString() ?? '',
      listingName: json['listingName']?.toString() ?? 'Listing',
      recipientName: json['recipientName']?.toString() ?? '',
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      status: status,
      message: json['message']?.toString() ?? '',
      serviceTitle: json['serviceTitle']?.toString() ?? json['listingName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterUserId': requesterUserId,
      'recipientUserId': recipientUserId,
      'listingId': listingId,
      'listingOwnerId': listingOwnerId,
      'listingName': listingName,
      'recipientName': recipientName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status,
      'message': message,
      'serviceTitle': serviceTitle,
    };
  }
}
