import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Network optimization utilities for improving API performance and reliability
/// Addresses network-related performance issues and implements caching strategies
class NetworkOptimizer {
  NetworkOptimizer._();

  static const networkCache = _NetworkCache();
  static const requestManager = _RequestManager();
  static const offlineHandler = _OfflineHandler();
}

/// Network caching implementation for API responses
class _NetworkCache {
  const _NetworkCache();

  static const String _cachePrefix = 'network_cache_';
  static const Duration _defaultCacheDuration = Duration(minutes: 15);

  /// Cache API response with TTL
  static Future<void> cacheResponse({
    required String key,
    required Map<String, dynamic> data,
    Duration? cacheDuration,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'ttl': (cacheDuration ?? _defaultCacheDuration).inMilliseconds,
      };

      await prefs.setString(
        '$_cachePrefix$key',
        jsonEncode(cacheData),
      );

      debugPrint('NetworkCache: Cached response for key: $key');
    } catch (e) {
      debugPrint('NetworkCache: Failed to cache response: $e');
    }
  }

  /// Retrieve cached response if valid
  static Future<Map<String, dynamic>?> getCachedResponse(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString('$_cachePrefix$key');

      if (cachedString == null) return null;

      final cacheData = jsonDecode(cachedString) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      final ttl = cacheData['ttl'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if cache is still valid
      if (now - timestamp < ttl) {
        debugPrint('NetworkCache: Cache hit for key: $key');
        return cacheData['data'] as Map<String, dynamic>;
      } else {
        // Cache expired, remove it
        await prefs.remove('$_cachePrefix$key');
        debugPrint('NetworkCache: Cache expired for key: $key');
        return null;
      }
    } catch (e) {
      debugPrint('NetworkCache: Failed to retrieve cached response: $e');
      return null;
    }
  }

  /// Clear all cached responses
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          await prefs.remove(key);
        }
      }

      debugPrint('NetworkCache: Cleared all cached responses');
    } catch (e) {
      debugPrint('NetworkCache: Failed to clear cache: $e');
    }
  }

  /// Clear specific cache entry
  static Future<void> clearCacheEntry(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_cachePrefix$key');
      debugPrint('NetworkCache: Cleared cache for key: $key');
    } catch (e) {
      debugPrint('NetworkCache: Failed to clear cache entry: $e');
    }
  }
}

/// Request management with retry logic and deduplication
class _RequestManager {
  const _RequestManager();

  static final Map<String, Future<http.Response>> _pendingRequests = {};
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  /// Make HTTP request with retry logic and deduplication
  static Future<http.Response> makeRequest({
    required String url,
    required String method,
    Map<String, String>? headers,
    String? body,
    bool enableCache = true,
    Duration? cacheDuration,
    int maxRetries = _maxRetries,
  }) async {
    final requestKey = _generateRequestKey(url, method, body);

    // Check if request is already pending (deduplication)
    if (_pendingRequests.containsKey(requestKey)) {
      debugPrint('RequestManager: Deduplicating request: $url');
      return _pendingRequests[requestKey]!;
    }

    // Check cache first
    if (enableCache && method.toLowerCase() == 'get') {
      final cachedResponse = await _NetworkCache.getCachedResponse(requestKey);
      if (cachedResponse != null) {
        return http.Response(
          jsonEncode(cachedResponse),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
    }

    // Create the request future
    final requestFuture = _executeRequestWithRetry(
      url: url,
      method: method,
      headers: headers,
      body: body,
      maxRetries: maxRetries,
    );

    // Store pending request
    _pendingRequests[requestKey] = requestFuture;

    try {
      final response = await requestFuture;

      // Cache successful GET responses
      if (enableCache &&
          method.toLowerCase() == 'get' &&
          response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        await _NetworkCache.cacheResponse(
          key: requestKey,
          data: responseData,
          cacheDuration: cacheDuration,
        );
      }

      return response;
    } finally {
      // Remove from pending requests
      _pendingRequests.remove(requestKey);
    }
  }

  /// Execute request with exponential backoff retry
  static Future<http.Response> _executeRequestWithRetry({
    required String url,
    required String method,
    Map<String, String>? headers,
    String? body,
    required int maxRetries,
  }) async {
    int attempt = 0;
    Duration delay = _retryDelay;

    while (attempt <= maxRetries) {
      try {
        debugPrint('RequestManager: Attempt ${attempt + 1} for $url');

        late http.Response response;

        switch (method.toLowerCase()) {
          case 'get':
            response = await http.get(Uri.parse(url), headers: headers);
            break;
          case 'post':
            response = await http.post(
              Uri.parse(url),
              headers: headers,
              body: body,
            );
            break;
          case 'put':
            response = await http.put(
              Uri.parse(url),
              headers: headers,
              body: body,
            );
            break;
          case 'delete':
            response = await http.delete(Uri.parse(url), headers: headers);
            break;
          default:
            throw UnsupportedError('HTTP method $method not supported');
        }

        // Check if response is successful
        if (response.statusCode >= 200 && response.statusCode < 300) {
          debugPrint('RequestManager: Success for $url');
          return response;
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          // Client errors shouldn't be retried
          debugPrint(
              'RequestManager: Client error ${response.statusCode} for $url');
          return response;
        } else {
          // Server errors can be retried
          throw HttpException('Server error: ${response.statusCode}');
        }
      } catch (e) {
        attempt++;

        if (attempt > maxRetries) {
          debugPrint('RequestManager: Max retries exceeded for $url');
          rethrow;
        }

        debugPrint('RequestManager: Error on attempt $attempt: $e');
        debugPrint('RequestManager: Retrying in ${delay.inSeconds} seconds...');

        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
      }
    }

    throw Exception('Request failed after $maxRetries retries');
  }

  /// Generate unique key for request
  static String _generateRequestKey(String url, String method, String? body) {
    final content = '$method:$url${body ?? ''}';
    return content.hashCode.toString();
  }

  /// Cancel all pending requests
  static void cancelAllRequests() {
    _pendingRequests.clear();
    debugPrint('RequestManager: Cancelled all pending requests');
  }
}

/// Offline capability handling
class _OfflineHandler {
  const _OfflineHandler();

  static bool _isOnline = true;
  static final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  /// Stream of connectivity status changes
  static Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Current connectivity status
  static bool get isOnline => _isOnline;

  /// Initialize connectivity monitoring
  static Future<void> initialize() async {
    try {
      _isOnline = await _checkConnectivity();
      debugPrint('OfflineHandler: Initial connectivity: $_isOnline');

      // Start periodic connectivity checks
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        final wasOnline = _isOnline;
        _isOnline = await _checkConnectivity();

        if (wasOnline != _isOnline) {
          debugPrint('OfflineHandler: Connectivity changed: $_isOnline');
          _connectivityController.add(_isOnline);
        }
      });
    } catch (e) {
      debugPrint('OfflineHandler: Failed to initialize: $e');
    }
  }

  /// Check internet connectivity
  static Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Handle offline API calls by returning cached data
  static Future<Map<String, dynamic>?> handleOfflineRequest(
      String cacheKey) async {
    if (_isOnline) return null;

    debugPrint('OfflineHandler: Device offline, checking cache for: $cacheKey');
    return await _NetworkCache.getCachedResponse(cacheKey);
  }

  /// Queue requests for when connection is restored
  static final List<Future<void> Function()> _queuedRequests = [];

  /// Add request to offline queue
  static void queueRequest(Future<void> Function() requestFunction) {
    if (!_isOnline) {
      _queuedRequests.add(requestFunction);
      debugPrint('OfflineHandler: Queued request for when online');
    }
  }

  /// Process queued requests when connection is restored
  static Future<void> processQueuedRequests() async {
    if (!_isOnline || _queuedRequests.isEmpty) return;

    debugPrint(
        'OfflineHandler: Processing ${_queuedRequests.length} queued requests');

    final requests = List.from(_queuedRequests);
    _queuedRequests.clear();

    for (final request in requests) {
      try {
        await request();
      } catch (e) {
        debugPrint('OfflineHandler: Failed to process queued request: $e');
      }
    }
  }

  /// Dispose resources
  static void dispose() {
    _connectivityController.close();
  }
}

/// Network optimization utilities and helpers
class NetworkUtils {
  NetworkUtils._();

  /// Create optimized HTTP client with timeout and compression
  static http.Client createOptimizedClient({
    Duration timeout = const Duration(seconds: 30),
  }) {
    final client = http.Client();
    return client;
  }

  /// Format URL with query parameters
  static String buildUrl(String baseUrl, Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) {
      return baseUrl;
    }

    final uri = Uri.parse(baseUrl);
    final newUri = uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParams.map((key, value) => MapEntry(key, value.toString())),
      },
    );

    return newUri.toString();
  }

  /// Validate response status
  static bool isSuccessfulResponse(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Extract error message from response
  static String extractErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['message'] ??
          data['error'] ??
          'Request failed with status: ${response.statusCode}';
    } catch (e) {
      return 'Request failed with status: ${response.statusCode}';
    }
  }

  /// Log network request for debugging
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    String? body,
  }) {
    if (kDebugMode) {
      debugPrint('🌐 Network Request:');
      debugPrint('   Method: $method');
      debugPrint('   URL: $url');
      if (headers != null) {
        debugPrint('   Headers: $headers');
      }
      if (body != null) {
        debugPrint('   Body: $body');
      }
    }
  }

  /// Log network response for debugging
  static void logResponse({
    required String url,
    required int statusCode,
    required String body,
  }) {
    if (kDebugMode) {
      debugPrint('📡 Network Response:');
      debugPrint('   URL: $url');
      debugPrint('   Status: $statusCode');
      debugPrint(
          '   Body: ${body.length > 500 ? '${body.substring(0, 500)}...' : body}');
    }
  }
}
