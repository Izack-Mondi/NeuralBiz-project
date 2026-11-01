import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiUser {
  const ApiUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.country,
    this.location,
    this.interests = const <String>[],
    this.status,
    this.emailVerified,
    this.phoneVerified,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? country;
  final String? location;
  final List<String> interests;
  final String? status;
  final bool? emailVerified;
  final bool? phoneVerified;

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      country: json['country'] as String?,
      location: json['location'] as String?,
      interests: (json['interests'] as List<dynamic>? ?? const <dynamic>[])
          .map((interest) => interest.toString())
          .toList(),
      status: json['status'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      phoneVerified: json['phoneVerified'] as bool?,
    );
  }
}

class PostAuthor {
  const PostAuthor({
    required this.id,
    required this.fullName,
    this.email = '',
    this.phoneNumber,
    this.location,
    this.isVerified = false,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? location;
  final bool isVerified;

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      id: json['id'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}

class PostProduct {
  const PostProduct({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.unit,
    required this.category,
    this.location,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.mediaType,
  });

  final String id;
  final String name;
  final String? description;
  final double price;
  final String unit;
  final String category;
  final String? location;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String mediaType;

  factory PostProduct.fromJson(Map<String, dynamic> json) {
    return PostProduct(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
      category: json['category'] as String? ?? '',
      location: json['location'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mediaType: json['mediaType'] as String? ?? 'IMAGE',
    );
  }
}

class PostService {
  const PostService({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    this.location,
    this.price,
    this.availability,
    this.experience,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.mediaType,
    required this.rating,
    required this.reviews,
  });

  final String id;
  final String name;
  final String? description;
  final String category;
  final String? location;
  final String? price;
  final String? availability;
  final String? experience;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String mediaType;
  final double rating;
  final int reviews;

  factory PostService.fromJson(Map<String, dynamic> json) {
    return PostService(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? '',
      location: json['location'] as String?,
      price: json['price'] as String?,
      availability: json['availability'] as String?,
      experience: json['experience'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mediaType: json['mediaType'] as String? ?? 'IMAGE',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as int? ?? 0,
    );
  }
}

class FeedPost {
  const FeedPost({
    required this.id,
    required this.author,
    required this.type,
    this.vertical,
    this.caption,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.mediaType,
    this.status,
    this.rejectionReason,
    this.product,
    this.service,
    this.offering,
    this.media,
    required this.likesCount,
    required this.commentsCount,
    required this.viewsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final PostAuthor author;
  final String type;
  final String? vertical;
  final String? caption;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String mediaType;
  final String? status;
  final String? rejectionReason;
  final PostProduct? product;
  final PostService? service;
  final Map<String, dynamic>? offering;
  final Map<String, dynamic>? media;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isVideo {
    if (media != null && media!['hasVideo'] == true) return true;
    return mediaType == 'VIDEO';
  }

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'] as String,
      author: PostAuthor.fromJson(json['author'] as Map<String, dynamic>),
      type: json['type'] as String? ?? 'GENERAL',
      vertical: json['vertical'] as String?,
      caption: json['caption'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mediaType: json['mediaType'] as String? ?? 'IMAGE',
      status: json['status'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      product: json['product'] != null
          ? PostProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      service: json['service'] != null
          ? PostService.fromJson(json['service'] as Map<String, dynamic>)
          : null,
      offering: json['offering'] as Map<String, dynamic>?,
      media: json['media'] as Map<String, dynamic>?,
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class PageInfo {
  const PageInfo({required this.hasNextPage, this.endCursor});

  final bool hasNextPage;
  final String? endCursor;

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      endCursor: json['endCursor'] as String?,
    );
  }
}

class PostEdge {
  const PostEdge({required this.node, required this.cursor});

  final FeedPost node;
  final String cursor;

  factory PostEdge.fromJson(Map<String, dynamic> json) {
    return PostEdge(
      node: FeedPost.fromJson(json['node'] as Map<String, dynamic>),
      cursor: json['cursor'] as String,
    );
  }
}

class FeedConnection {
  const FeedConnection({required this.edges, required this.pageInfo});

  final List<PostEdge> edges;
  final PageInfo pageInfo;

  factory FeedConnection.fromJson(Map<String, dynamic> json) {
    return FeedConnection(
      edges: (json['edges'] as List<dynamic>? ?? const <dynamic>[])
          .map((edge) => PostEdge.fromJson(edge as Map<String, dynamic>))
          .toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );
  }
}

class AuthPayload {
  const AuthPayload({
    this.accessToken,
    this.refreshToken,
    this.verificationRequired,
    this.message,
    required this.user,
  });

  final String? accessToken;
  final String? refreshToken;
  final bool? verificationRequired;
  final String? message;
  final ApiUser user;

  factory AuthPayload.fromJson(Map<String, dynamic> json) {
    return AuthPayload(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      verificationRequired: json['verificationRequired'] as bool?,
      message: json['message'] as String?,
      user: ApiUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class ApiClient {
  ApiClient({http.Client? client, this._accessToken})
    : _client = client ?? http.Client();

  // --- REAL BACKEND CALL (disabled for offline UI development) ---
  static final Uri _endpoint = _resolveEndpoint();

  static Uri _resolveEndpoint() {
    // Allows the API URL to be supplied at runtime:
    //
    // flutter run -d windows \
    //   --dart-define=NEXIFY_API_URL=http://127.0.0.1:3000/graphql
    //
    // or for Android emulator:
    //
    // flutter run \
    //   --dart-define=NEXIFY_API_URL=http://10.0.2.2:3000/graphql

    const configuredUrl = String.fromEnvironment('NEXIFY_API_URL');

    if (configuredUrl.isNotEmpty) {
      return Uri.parse(configuredUrl);
    }

    // Android emulator -> host computer.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Uri.parse('http://10.0.2.2:3000/graphql');
    }

    // Windows/Desktop -> same computer.
    return Uri.parse('http://127.0.0.1:3000/graphql');
  }

  static Uri get endpoint => _endpoint;
  // --- END REAL BACKEND CALL ---

  final http.Client _client;
  String? _accessToken;

  set accessToken(String? value) {
    _accessToken = value;
  }

  Future<AuthPayload> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    String? verificationMethod,
  }) async {
    debugPrint(
      'DEBUG register called with verificationMethod: $verificationMethod',
    );
    final result = await _request(
      r'''
        mutation Register($input: RegisterInput!) {
          register(input: $input) {
            accessToken
            refreshToken
            verificationRequired
            message
            user {
              id
              fullName
              email
              phoneNumber
              country
              location
              interests
              status
              emailVerified
              phoneVerified
            }
          }
        }
      ''',
      {
        'input': {
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'verificationMethod': verificationMethod ?? 'EMAIL',
        },
      },
    );
    return AuthPayload.fromJson(result['register'] as Map<String, dynamic>);
  }

  Future<AuthPayload> verifyRegistration({
    required String userId,
    required String code,
  }) async {
    final result = await _request(
      r'''
        mutation VerifyRegistration($input: VerifyRegistrationInput!) {
          verifyRegistration(input: $input) {
            accessToken
            refreshToken
            verificationRequired
            message
            user {
              id
              fullName
              email
              phoneNumber
              country
              location
              interests
              status
              emailVerified
              phoneVerified
            }
          }
        }
      ''',
      {
        'input': {'userId': userId, 'code': code},
      },
    );
    return AuthPayload.fromJson(
      result['verifyRegistration'] as Map<String, dynamic>,
    );
  }

  Future<AuthPayload> resendVerificationCode({
    String? userId,
    String? email,
    String? verificationMethod,
  }) async {
    final result = await _request(
      r'''
        mutation ResendVerificationCode($input: ResendVerificationCodeInput!) {
          resendVerificationCode(input: $input) {
            accessToken
            refreshToken
            verificationRequired
            message
            user {
              id
              fullName
              email
              phoneNumber
              country
              location
              interests
              status
              emailVerified
              phoneVerified
            }
          }
        }
      ''',
      {
        'input': {
          'userId': userId,
          'email': email,
          if (verificationMethod != null)
            'verificationMethod': verificationMethod,
        },
      },
    );
    return AuthPayload.fromJson(
      result['resendVerificationCode'] as Map<String, dynamic>,
    );
  }

  Future<AuthPayload> completePasswordSetup({
    required String userId,
    required String password,
  }) async {
    final result = await _request(
      r'''
        mutation CompletePasswordSetup($input: CompletePasswordSetupInput!) {
          completePasswordSetup(input: $input) {
            accessToken
            refreshToken
            verificationRequired
            message
            user {
              id
              fullName
              email
              phoneNumber
              country
              location
              interests
              status
              emailVerified
              phoneVerified
            }
          }
        }
      ''',
      {
        'input': {'userId': userId, 'password': password},
      },
    );
    return AuthPayload.fromJson(
      result['completePasswordSetup'] as Map<String, dynamic>,
    );
  }

  Future<AuthPayload> completeProfile({
    required String userId,
    required String fullName,
    String? country,
    String? location,
    List<String>? interests,
  }) async {
    final result = await _request(
      r'''
        mutation CompleteProfile($input: CompleteProfileInput!) {
          completeProfile(input: $input) {
            accessToken
            refreshToken
            verificationRequired
            message
            user {
              id
              fullName
              email
              phoneNumber
              country
              location
              interests
              status
              emailVerified
              phoneVerified
            }
          }
        }
      ''',
      {
        'input': {
          'userId': userId,
          'fullName': fullName,
          'country': country,
          'location': location,
          'interests': interests,
        },
      },
    );
    return AuthPayload.fromJson(
      result['completeProfile'] as Map<String, dynamic>,
    );
  }

  Future<AuthPayload> login({
    required String identifier,
    required String password,
  }) async {
    final result = await _request(
      r'''
        mutation Login($input: LoginInput!) {
          login(input: $input) {
            accessToken
            refreshToken
            verificationRequired
            message
            user {
              id
              fullName
              email
              phoneNumber
              country
              location
              interests
              status
              emailVerified
              phoneVerified
            }
          }
        }
      ''',
      {
        'input': {'identifier': identifier, 'password': password},
      },
    );
    return AuthPayload.fromJson(result['login'] as Map<String, dynamic>);
  }

  Future<AuthPayload> refreshSession({required String refreshToken}) async {
    final result = await _request(
      r'''
        mutation RefreshSession($input: RefreshSessionInput!) {
          refreshSession(input: $input) {
            accessToken
            refreshToken
            verificationRequired
            message
            user {
              id
              fullName
              email
              phoneNumber
              country
              location
              interests
              status
              emailVerified
              phoneVerified
            }
          }
        }
      ''',
      {
        'input': {'refreshToken': refreshToken},
      },
    );
    return AuthPayload.fromJson(
      result['refreshSession'] as Map<String, dynamic>,
    );
  }

  Future<String> logout({required String refreshToken}) async {
    final result = await _request(
      r'''
        mutation Logout($input: LogoutInput!) {
          logout(input: $input)
        }
      ''',
      {
        'input': {'refreshToken': refreshToken},
      },
    );

    return result['logout'] as String;
  }

  Future<ApiUser> me() async {
    final result = await _request(r'''
        query Me {
          me {
            id
            fullName
            email
            phoneNumber
            country
            location
            interests
            status
            emailVerified
            phoneVerified
          }
        }
      ''', const {});

    return ApiUser.fromJson(result['me'] as Map<String, dynamic>);
  }

  Future<FeedConnection> getHomeFeed({
    int first = 20,
    String? after,
    String? tab,
    String? type,
  }) async {
    final result = await _request(
      r'''
        query HomeFeed($input: FeedInput!) {
          homeFeed(input: $input) {
            edges {
              node {
                id
                type
                vertical
                caption
                mediaUrl
                thumbnailUrl
                mediaType
                status
                rejectionReason
                likesCount
                commentsCount
                viewsCount
                createdAt
                updatedAt
                author {
                  id
                  fullName
                  location
                  isVerified
                }
                product {
                  id
                  name
                  description
                  price
                  unit
                  category
                  location
                  mediaUrl
                  thumbnailUrl
                  mediaType
                }
                service {
                  id
                  name
                  description
                  category
                  location
                  price
                  availability
                  experience
                  mediaUrl
                  thumbnailUrl
                  mediaType
                  rating
                  reviews
                }
                offering {
                  id
                  title
                  category
                  description
                  skills
                  yearsExperience
                  startingPrice
                  priceUnit
                  county
                }
                media {
                  kind
                  thumbnailUrl
                  previewUrl
                  blurhash
                  durationSec
                  width
                  height
                  hasVideo
                }
              }
              cursor
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }
      ''',
      {
        'input': {
          'first': first,
          if (after != null) 'after': after,
          if (tab != null) 'tab': tab,
          if (type != null) 'type': type,
        },
      },
    );

    return FeedConnection.fromJson(result['homeFeed'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> playback({required String postId}) async {
    final result = await _request(
      r'''
        query Playback($postId: ID!) {
          playback(postId: $postId) {
            hlsUrl
            durationSec
            expiresAt
          }

        }
      ''',
      {'postId': postId},
    );

    return result['playback'] as Map<String, dynamic>;
  }

  Future<String> createServiceOffering({
    required String title,
    required String category,
    required String vertical,
    required String county,
    String? description,
    List<String> skills = const <String>[],
    int yearsExperience = 0,
    double? startingPrice,
    String? priceUnit,
    String? demoAssetId,
  }) async {
    final input = <String, dynamic>{
      'title': title,
      'category': category,
      'vertical': vertical,
      'county': county,
      'skills': skills,
      'yearsExperience': yearsExperience,
      if (description != null && description.isNotEmpty)
        'description': description,
      if (startingPrice != null) 'startingPrice': startingPrice,
      if (priceUnit != null && priceUnit.isNotEmpty) 'priceUnit': priceUnit,
      if (demoAssetId != null) 'demoAssetId': demoAssetId,
    };
    final result = await _request(
      r'''
        mutation CreateServiceOffering($input: CreateServiceOfferingInput!) {
          createServiceOffering(input: $input)
        }
      ''',
      {'input': input},
    );
    return result['createServiceOffering'] as String;
  }

  Future<String> uploadVideoAndComplete(String path) async {
    final file = File(path);
    final sizeBytes = await file.length();
    final contentType = _videoContentType(path);
    final result = await _request(
      r'''
        mutation RequestVideoUpload($input: RequestVideoUploadInput!) {
          requestVideoUpload(input: $input) {
            assetId
            uploadUrl
          }
        }
      ''',
      {
        'input': {'contentType': contentType, 'sizeBytes': sizeBytes},
      },
    );
    final upload = result['requestVideoUpload'] as Map<String, dynamic>;
    final response = await _client.put(
      Uri.parse(upload['uploadUrl'] as String),
      headers: {'Content-Type': contentType},
      body: await file.readAsBytes(),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Video upload failed (${response.statusCode}).');
    }

    final completed = await _request(
      r'''
        mutation CompleteUpload($assetId: ID!) {
          completeUpload(assetId: $assetId) {
            id
          }
        }
      ''',
      {'assetId': upload['assetId']},
    );
    return (completed['completeUpload'] as Map<String, dynamic>)['id']
        as String;
  }

  String _videoContentType(String path) {
    final extension = path.split('.').last.toLowerCase();
    return switch (extension) {
      'mov' => 'video/quicktime',
      'webm' => 'video/webm',
      _ => 'video/mp4',
    };
  }

  Future<Map<String, dynamic>> searchUsers({
    String? query,
    int first = 20,
    String? after,
  }) async {
    final result = await _request(
      r'''
        query SearchUsers($query: String, $first: Int, $after: String) {
          searchUsers(query: $query, first: $first, after: $after) {
            users {
              id
              user {
                id
                fullName
                location
                county
                interests
                emailVerified
                phoneVerified
                isVerified
              }
              connectionStatus
              connectionRequestId
            }
            hasNextPage
            endCursor
          }
        }
      ''',
      {'query': query, 'first': first, 'after': after},
    );
    return result['searchUsers'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendConnectionRequest({
    required String receiverId,
  }) async {
    final result = await _request(
      r'''
        mutation SendConnectionRequest($receiverId: ID!) {
          sendConnectionRequest(receiverId: $receiverId) {
            id
            sender {
              id
              fullName
              location
              county
              interests
              emailVerified
              phoneVerified
              isVerified
            }
            receiver {
              id
              fullName
              location
              county
              interests
              emailVerified
              phoneVerified
              isVerified
            }
            status
            createdAt
            updatedAt
          }
        }
      ''',
      {'receiverId': receiverId},
    );
    return result['sendConnectionRequest'] as Map<String, dynamic>;
  }

  Future<String> cancelConnectionRequest({required String requestId}) async {
    final result = await _request(
      r'''
        mutation CancelConnectionRequest($requestId: ID!) {
          cancelConnectionRequest(requestId: $requestId)
        }
      ''',
      {'requestId': requestId},
    );
    return result['cancelConnectionRequest'] as String;
  }

  Future<String> acceptConnectionRequest({required String requestId}) async {
    final result = await _request(
      r'''
        mutation AcceptConnectionRequest($requestId: ID!) {
          acceptConnectionRequest(requestId: $requestId)
        }
      ''',
      {'requestId': requestId},
    );
    return result['acceptConnectionRequest'] as String;
  }

  Future<String> rejectConnectionRequest({required String requestId}) async {
    final result = await _request(
      r'''
        mutation RejectConnectionRequest($requestId: ID!) {
          rejectConnectionRequest(requestId: $requestId)
        }
      ''',
      {'requestId': requestId},
    );
    return result['rejectConnectionRequest'] as String;
  }

  Future<Map<String, dynamic>> getPendingRequests({
    String type = 'all',
    int first = 20,
    String? after,
  }) async {
    final result = await _request(
      r'''
        query PendingRequests($type: String, $first: Int, $after: String) {
          pendingRequests(type: $type, first: $first, after: $after) {
            requests {
              id
              sender {
                id
                fullName
                location
                county
                interests
                emailVerified
                phoneVerified
                isVerified
              }
              receiver {
                id
                fullName
                location
                county
                interests
                emailVerified
                phoneVerified
                isVerified
              }
              status
              createdAt
              updatedAt
            }
            hasNextPage
            endCursor
          }
        }
      ''',
      {'type': type, 'first': first, 'after': after},
    );
    return result['pendingRequests'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getConnections({
    int first = 20,
    String? after,
  }) async {
    final result = await _request(
      r'''
        query Connections($first: Int, $after: String) {
          connections(first: $first, after: $after) {
            connections {
              id
              user {
                id
                fullName
                location
                county
                interests
                emailVerified
                phoneVerified
                isVerified
              }
              createdAt
            }
            hasNextPage
            endCursor
          }
        }
      ''',
      {'first': first, 'after': after},
    );
    return result['connections'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> opportunityInsights({
    int first = 20,
    String? after,
  }) async {
    final result = await _request(
      r'''
        query OpportunityInsights($first: Int, $after: String) {
          opportunityInsights(first: $first, after: $after) {
            insights {
              id
              key
              vertical
              category
              region
              score
              payload
              postId
              createdAt
            }
            hasNextPage
            endCursor
          }
        }
      ''',
      {'first': first, if (after != null) 'after': after},
    );

    return result['opportunityInsights'] as Map<String, dynamic>;
  }

  Future<String> createProduct({
    required String name,
    required double price,
    required String unit,
    required String category,
    required String sellerId,
    String? description,
    String? location,
    String? mediaUrl,
    String? thumbnailUrl,
    String? mediaType,
  }) async {
    final result = await _request(
      r'''
        mutation CreateProduct(
          $name: String!
          $price: Float!
          $unit: String!
          $category: String!
          $sellerId: String!
          $description: String
          $location: String
          $mediaUrl: String
          $thumbnailUrl: String
          $mediaType: MediaType
        ) {
          createProduct(
            name: $name
            price: $price
            unit: $unit
            category: $category
            sellerId: $sellerId
            description: $description
            location: $location
            mediaUrl: $mediaUrl
            thumbnailUrl: $thumbnailUrl
            mediaType: $mediaType
          )
        }
      ''',
      {
        'name': name,
        'price': price,
        'unit': unit,
        'category': category,
        'sellerId': sellerId,
        if (description != null) 'description': description,
        if (location != null) 'location': location,
        if (mediaUrl != null) 'mediaUrl': mediaUrl,
        if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
        if (mediaType != null) 'mediaType': mediaType,
      },
    );

    return result['createProduct'] as String;
  }

  Future<String> createPost({
    required String authorId,
    required String type,
    String? caption,
    String? mediaUrl,
    String? thumbnailUrl,
    String? mediaType,
    String? productId,
    String? serviceId,
  }) async {
    final result = await _request(
      r'''
        mutation CreatePost(
          $authorId: String!
          $type: PostType!
          $caption: String
          $mediaUrl: String
          $thumbnailUrl: String
          $mediaType: MediaType
          $productId: String
          $serviceId: String
        ) {
          createPost(
            authorId: $authorId
            type: $type
            caption: $caption
            mediaUrl: $mediaUrl
            thumbnailUrl: $thumbnailUrl
            mediaType: $mediaType
            productId: $productId
            serviceId: $serviceId
          )
        }
      ''',
      {
        'authorId': authorId,
        'type': type,
        if (caption != null) 'caption': caption,
        if (mediaUrl != null) 'mediaUrl': mediaUrl,
        if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
        if (mediaType != null) 'mediaType': mediaType,
        if (productId != null) 'productId': productId,
        if (serviceId != null) 'serviceId': serviceId,
      },
    );

    return result['createPost'] as String;
  }

  Future<String> createService({
    required String name,
    required String category,
    required String providerId,
    String? description,
    String? location,
    String? price,
    String? availability,
    String? experience,
    String? mediaUrl,
    String? thumbnailUrl,
    String? mediaType,
  }) async {
    final result = await _request(
      r'''
        mutation CreateService(
          $name: String!
          $category: String!
          $providerId: String!
          $description: String
          $location: String
          $price: String
          $availability: String
          $experience: String
          $mediaUrl: String
          $thumbnailUrl: String
          $mediaType: MediaType
        ) {
          createService(
            name: $name
            category: $category
            providerId: $providerId
            description: $description
            location: $location
            price: $price
            availability: $availability
            experience: $experience
            mediaUrl: $mediaUrl
            thumbnailUrl: $thumbnailUrl
            mediaType: $mediaType
          )
        }
      ''',
      {
        'name': name,
        'category': category,
        'providerId': providerId,
        if (description != null) 'description': description,
        if (location != null) 'location': location,
        if (price != null) 'price': price,
        if (availability != null) 'availability': availability,
        if (experience != null) 'experience': experience,
        if (mediaUrl != null) 'mediaUrl': mediaUrl,
        if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
        if (mediaType != null) 'mediaType': mediaType,
      },
    );

    return result['createService'] as String;
  }

  Future<Map<String, dynamic>> _request(
    String query,
    Map<String, dynamic> variables,
  ) async {
    // --- REAL BACKEND CALL (disabled for offline UI development) ---
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
    };

    late final http.Response response;

    try {
      response = await _client.post(
        _endpoint,
        headers: headers,
        body: jsonEncode({'query': query, 'variables': variables}),
      );

      // Temporary debugging information.
      // No passwords, tokens, verification codes, or API keys
      // are logged here.
      debugPrint('NEXIFY API ENDPOINT: $_endpoint');
      debugPrint('NEXIFY HTTP STATUS: ${response.statusCode}');
      debugPrint('NEXIFY RESPONSE: ${response.body}');
    } on Exception catch (error) {
      throw ApiException(
        'Unable to reach Nexify at $_endpoint.\n'
        'Please make sure the Nexify backend is running '
        'and the GraphQL endpoint is correct.\n'
        'Technical error: $error',
      );
    }

    late final Map<String, dynamic> body;

    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw ApiException(
        'The Nexify server returned an unexpected response '
        '(HTTP ${response.statusCode}).',
      );
    } on TypeError {
      throw ApiException(
        'The Nexify server returned an invalid response format '
        '(HTTP ${response.statusCode}).',
      );
    }

    final errors = body['errors'] as List<dynamic>?;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final firstError = errors?.isNotEmpty == true
          ? errors!.first as Map<String, dynamic>?
          : null;

      throw ApiException(
        firstError?['message'] as String? ??
            'Request failed with HTTP ${response.statusCode}.',
      );
    }

    if (errors != null && errors.isNotEmpty) {
      final firstError = errors.first as Map<String, dynamic>?;

      throw ApiException(
        firstError?['message'] as String? ?? 'The GraphQL request failed.',
      );
    }

    final data = body['data'];

    if (data is! Map<String, dynamic>) {
      throw const ApiException(
        'The Nexify server returned no valid GraphQL data.',
      );
    }

    return data;
    // --- END REAL BACKEND CALL ---
  }
}
