import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'http_constants.dart';

/// HttpService wrapper around http.Client with enhanced capabilities
class HttpService {
  final http.Client _client;
  final String baseUrl;
  final Duration timeout;
  final Map<String, String>? defaultHeaders;
  final Function(http.Request)? requestInterceptor;
  final Function(http.Response)? responseInterceptor;
  final int maxRetries;
  final Duration retryDelay;

  HttpService({
    http.Client? client,
    String? baseUrl,
    Duration? timeout,
    this.defaultHeaders,
    this.requestInterceptor,
    this.responseInterceptor,
    this.maxRetries = 0,
    this.retryDelay = const Duration(seconds: 1),
  })  : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? dotenv.env['BASE_URL'] ?? 'https://staging.chamberofsecrets.8club.co',
        timeout = timeout ??
            Duration(
              seconds: int.tryParse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '30') ?? 30,
            );

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
    bool retryOnFailure = false,
  }) async {
    return _executeRequest(
      method: HttpMethod.get,
      endpoint: endpoint,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
      retryOnFailure: retryOnFailure,
    );
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
    bool retryOnFailure = false,
  }) async {
    return _executeRequest(
      method: HttpMethod.post,
      endpoint: endpoint,
      headers: headers,
      body: body,
      timeout: timeout,
      retryOnFailure: retryOnFailure,
    );
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
    bool retryOnFailure = false,
  }) async {
    return _executeRequest(
      method: HttpMethod.put,
      endpoint: endpoint,
      headers: headers,
      body: body,
      timeout: timeout,
      retryOnFailure: retryOnFailure,
    );
  }

  /// PATCH request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
    bool retryOnFailure = false,
  }) async {
    return _executeRequest(
      method: HttpMethod.patch,
      endpoint: endpoint,
      headers: headers,
      body: body,
      timeout: timeout,
      retryOnFailure: retryOnFailure,
    );
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
    bool retryOnFailure = false,
  }) async {
    return _executeRequest(
      method: HttpMethod.delete,
      endpoint: endpoint,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
      retryOnFailure: retryOnFailure,
    );
  }

  /// Upload file using multipart/form-data
  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    String filePath, {
    String fileFieldName = 'file',
    Map<String, String>? fields,
    Map<String, String>? headers,
    Duration? timeout,
    Function(int sent, int total)? onProgress,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest(HttpMethod.post, uri);

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(fileFieldName, filePath),
      );

      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add headers
      final mergedHeaders = _mergeHeaders(headers);
      request.headers.addAll(mergedHeaders);

      // Apply request interceptor
      if (requestInterceptor != null) {
        // Note: Interceptor would need to work with MultipartRequest
        // For now, we'll skip it for multipart requests
      }

      _logRequest('${HttpMethod.post} (Multipart)', uri.toString());

      final streamedResponse = await request.send().timeout(
        timeout ?? this.timeout,
      );

      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timeout');
    } catch (e) {
      if (e is NetworkException || e is ServerException || e is HttpException) {
        rethrow;
      }
      throw HttpException('File upload failed: $e');
    }
  }

  /// Execute HTTP request with retry logic
  Future<Map<String, dynamic>> _executeRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Duration? timeout,
    bool retryOnFailure = false,
  }) async {
    int attempts = 0;
    final maxAttempts = retryOnFailure ? maxRetries + 1 : 1;

    while (attempts < maxAttempts) {
      try {
        final uri = Uri.parse('$baseUrl$endpoint').replace(
          queryParameters: queryParameters?.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        );

        final mergedHeaders = _mergeHeaders(headers);
        if (method != HttpMethod.get && method != HttpMethod.delete) {
          mergedHeaders[HttpHeader.contentType] = HttpContentType.json;
        }

        http.Request request;
        switch (method) {
          case HttpMethod.get:
            request = http.Request(HttpMethod.get, uri);
            break;
          case HttpMethod.post:
            request = http.Request(HttpMethod.post, uri);
            request.body = body is String ? body : jsonEncode(body);
            break;
          case HttpMethod.put:
            request = http.Request(HttpMethod.put, uri);
            request.body = body is String ? body : jsonEncode(body);
            break;
          case HttpMethod.patch:
            request = http.Request(HttpMethod.patch, uri);
            request.body = body is String ? body : jsonEncode(body);
            break;
          case HttpMethod.delete:
            request = http.Request(HttpMethod.delete, uri);
            break;
          default:
            throw HttpException('Unsupported HTTP method: $method');
        }

        request.headers.addAll(mergedHeaders);

        // Apply request interceptor
        if (requestInterceptor != null) {
          requestInterceptor!(request);
        }

        _logRequest(method, uri.toString(), body: request.body);

        final streamedResponse = await _client
            .send(request)
            .timeout(timeout ?? this.timeout);

        final response = await http.Response.fromStream(streamedResponse);

        // Apply response interceptor
        if (responseInterceptor != null) {
          responseInterceptor!(response);
        }

        return _handleResponse(response);
      } on SocketException {
        if (attempts < maxAttempts - 1 && retryOnFailure) {
          attempts++;
          await Future.delayed(retryDelay * attempts);
          continue;
        }
        throw NetworkException('No internet connection');
      } on TimeoutException catch (_) {
        if (attempts < maxAttempts - 1 && retryOnFailure) {
          attempts++;
          await Future.delayed(retryDelay * attempts);
          continue;
        }
        throw NetworkException('Request timeout');
      } on HttpException catch (e) {
        if (attempts < maxAttempts - 1 && retryOnFailure && _isRetryableError(e)) {
          attempts++;
          await Future.delayed(retryDelay * attempts);
          continue;
        }
        rethrow;
      } catch (e) {
        if (e is NetworkException || e is ServerException) {
          rethrow;
        }
        throw HttpException('Unexpected error: $e');
      }
    }

    throw HttpException('Request failed after $maxAttempts attempts');
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    _logResponse(response.statusCode, response.body);

    if (HttpStatusCode.isSuccess(response.statusCode)) {
      try {
        if (response.body.isEmpty) {
          return {};
        }
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else if (decoded is List) {
          // Return list wrapped in a map for consistency
          return {'data': decoded};
        } else {
          return {'data': decoded};
        }
      } catch (e) {
        throw HttpException('Invalid JSON response: ${response.body}');
      }
    } else if (HttpStatusCode.isClientError(response.statusCode)) {
      // Client errors
      throw ClientException(
        'Client error: ${response.statusCode} - ${HttpStatusCode.getDescription(response.statusCode)}',
        response.statusCode,
        response.body,
      );
    } else if (HttpStatusCode.isServerError(response.statusCode)) {
      // Server errors
      throw ServerException(
        'Server error: ${response.statusCode} - ${HttpStatusCode.getDescription(response.statusCode)}',
        response.statusCode,
        response.body,
      );
    } else {
      throw HttpException(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    final merged = <String, String>{};
    if (defaultHeaders != null) {
      merged.addAll(defaultHeaders!);
    }
    if (headers != null) {
      merged.addAll(headers);
    }
    return merged;
  }

  bool _isRetryableError(HttpException error) {
    // Retry on network errors, timeouts, and 5xx server errors
    return error is NetworkException || error is ServerException;
  }

  void _logRequest(String method, String url, {String? body}) {
    debugPrint('[HttpService] $method $url');
    if (body != null && body.isNotEmpty) {
      // Mask sensitive data in logs
      final maskedBody = _maskSensitiveData(body);
      debugPrint('[HttpService] Request body: $maskedBody');
    }
  }

  void _logResponse(int statusCode, String body) {
    debugPrint('[HttpService] Response $statusCode');
    if (body.isNotEmpty && body.length < 1000) {
      // Only log small responses to avoid performance issues
      final maskedBody = _maskSensitiveData(body);
      debugPrint('[HttpService] Response body: $maskedBody');
    }
  }

  String _maskSensitiveData(String data) {
    // Mask common sensitive fields in JSON
    try {
      final json = jsonDecode(data);
      if (json is Map) {
        final masked = Map<String, dynamic>.from(json);
        final sensitiveFields = ['password', 'token', 'authorization', 'apiKey', 'secret'];
        for (final field in sensitiveFields) {
          if (masked.containsKey(field)) {
            masked[field] = '***MASKED***';
          }
        }
        return jsonEncode(masked);
      }
    } catch (e) {
      // If not JSON, return as is
    }
    return data;
  }

  void close() {
    _client.close();
  }
}

/// Base exception for HTTP errors
class HttpException implements Exception {
  final String message;

  const HttpException(this.message);

  @override
  String toString() => 'HttpException: $message';
}

/// Network-related exceptions (no internet, timeout, etc.)
class NetworkException extends HttpException {
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Server error exceptions (5xx status codes)
class ServerException extends HttpException {
  final int statusCode;
  final String? responseBody;

  ServerException(super.message, this.statusCode, [this.responseBody]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Client error exceptions (4xx status codes)
class ClientException extends HttpException {
  final int statusCode;
  final String? responseBody;

  ClientException(super.message, this.statusCode, [this.responseBody]);

  @override
  String toString() => 'ClientException: $message (Status: $statusCode)';
}

