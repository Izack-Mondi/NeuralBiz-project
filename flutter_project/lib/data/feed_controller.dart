import 'package:flutter/foundation.dart';
import 'api_client.dart';

class FeedController extends ChangeNotifier {
  final ApiClient _apiClient;
  final bool useMockData;

  FeedController(this._apiClient, {this.useMockData = true});

  List<PostEdge> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String? _errorMessage;
  String? _endCursor;
  bool _hasNextPage = false;

  List<PostEdge> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  bool get hasNextPage => _hasNextPage;

  Future<void> loadInitialFeed({String? type}) async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    _posts = [];
    _endCursor = null;
    _hasNextPage = false;
    notifyListeners();

    try {
      if (useMockData) {
        // Use mock data for development testing
        await Future.delayed(const Duration(milliseconds: 800));
        _posts = _generateMockPosts();
        _hasNextPage = false;
        _hasError = false;
      } else {
        final connection = await _apiClient.getHomeFeed(
          first: 20,
          type: type,
        );

        _posts = connection.edges;
        _endCursor = connection.pageInfo.endCursor;
        _hasNextPage = connection.pageInfo.hasNextPage;
        _hasError = false;
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      debugPrint('Error loading feed: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreFeed({String? type}) async {
    if (_isLoadingMore || !_hasNextPage || _endCursor == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      if (useMockData) {
        // Mock data doesn't support pagination in this version
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        final connection = await _apiClient.getHomeFeed(
          first: 20,
          after: _endCursor,
          type: type,
        );

        _posts.addAll(connection.edges);
        _endCursor = connection.pageInfo.endCursor;
        _hasNextPage = connection.pageInfo.hasNextPage;
        _hasError = false;
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      debugPrint('Error loading more feed: $error');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshFeed({String? type}) async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      if (useMockData) {
        // Use mock data for development testing
        await Future.delayed(const Duration(milliseconds: 800));
        _posts = _generateMockPosts();
        _hasNextPage = false;
        _hasError = false;
      } else {
        final connection = await _apiClient.getHomeFeed(
          first: 20,
          type: type,
        );

        _posts = connection.edges;
        _endCursor = connection.pageInfo.endCursor;
        _hasNextPage = connection.pageInfo.hasNextPage;
        _hasError = false;
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      debugPrint('Error refreshing feed: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Mock data generation for development testing
  List<PostEdge> _generateMockPosts() {
    final now = DateTime.now();
    
    return [
      PostEdge(
        node: FeedPost(
          id: '1',
          author: PostAuthor(
            id: 'author1',
            fullName: 'Grace Wanjiku',
            email: 'grace@example.com',
            location: 'Kiambu, Kenya',
          ),
          type: 'MARKETPLACE',
          caption: 'Fresh sukuma wiki straight from my farm! Eat healthy, live healthy. Available in bulk orders at wholesale prices.',
          mediaUrl: null,
          thumbnailUrl: null,
          mediaType: 'TEXT',
          product: PostProduct(
            id: 'prod1',
            name: 'Fresh Sukuma Wiki',
            description: 'Organically grown kale leaves',
            price: 50.0,
            unit: 'bunch',
            category: 'Vegetables',
            location: 'Kiambu, Kenya',
            mediaType: 'IMAGE',
          ),
          service: null,
          likesCount: 8400,
          commentsCount: 342,
          viewsCount: 12500,
          createdAt: now.subtract(const Duration(hours: 2)),
          updatedAt: now.subtract(const Duration(hours: 2)),
        ),
        cursor: 'cursor1',
      ),
      PostEdge(
        node: FeedPost(
          id: '2',
          author: PostAuthor(
            id: 'author2',
            fullName: 'Nexify Business',
            email: 'business@nexify.com',
            location: 'Nairobi, Kenya',
          ),
          type: 'OPPORTUNITY',
          caption: 'Discover new opportunities and connect with businesses around you. Join our growing network of entrepreneurs and service providers.',
          mediaUrl: null,
          thumbnailUrl: null,
          mediaType: 'TEXT',
          product: null,
          service: PostService(
            id: 'service1',
            name: 'Business Consulting',
            description: 'Professional business consulting services for startups and SMEs',
            category: 'Business Services',
            location: 'Nairobi, Kenya',
            price: '5000 KES/hour',
            availability: 'Mon-Fri, 9AM-5PM',
            experience: '5+ years',
            mediaType: 'IMAGE',
            rating: 4.8,
            reviews: 127,
          ),
          likesCount: 5700,
          commentsCount: 218,
          viewsCount: 8900,
          createdAt: now.subtract(const Duration(hours: 5)),
          updatedAt: now.subtract(const Duration(hours: 5)),
        ),
        cursor: 'cursor2',
      ),
      PostEdge(
        node: FeedPost(
          id: '3',
          author: PostAuthor(
            id: 'author3',
            fullName: 'John Kamau',
            email: 'john@example.com',
            location: 'Nakuru, Kenya',
          ),
          type: 'MARKETPLACE',
          caption: 'High-quality agricultural equipment for sale. Tractors, plows, and irrigation systems available at competitive prices.',
          mediaUrl: null,
          thumbnailUrl: null,
          mediaType: 'TEXT',
          product: PostProduct(
            id: 'prod2',
            name: 'Agricultural Tractor',
            description: 'Heavy-duty tractor for farming operations',
            price: 2500000.0,
            unit: 'piece',
            category: 'Equipment',
            location: 'Nakuru, Kenya',
            mediaType: 'IMAGE',
          ),
          service: null,
          likesCount: 3200,
          commentsCount: 156,
          viewsCount: 5600,
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        cursor: 'cursor3',
      ),
      PostEdge(
        node: FeedPost(
          id: '4',
          author: PostAuthor(
            id: 'author4',
            fullName: 'Sarah Mwangi',
            email: 'sarah@example.com',
            location: 'Mombasa, Kenya',
          ),
          type: 'SERVICE',
          caption: 'Professional photography services for events, weddings, and corporate functions. Capturing your precious moments with creativity and precision.',
          mediaUrl: null,
          thumbnailUrl: null,
          mediaType: 'TEXT',
          product: null,
          service: PostService(
            id: 'service2',
            name: 'Professional Photography',
            description: 'Event and wedding photography services',
            category: 'Creative Services',
            location: 'Mombasa, Kenya',
            price: '15000 KES/event',
            availability: 'Weekends and weekdays',
            experience: '8+ years',
            mediaType: 'IMAGE',
            rating: 4.9,
            reviews: 234,
          ),
          likesCount: 4500,
          commentsCount: 289,
          viewsCount: 7800,
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
        cursor: 'cursor4',
      ),
    ];
  }
}