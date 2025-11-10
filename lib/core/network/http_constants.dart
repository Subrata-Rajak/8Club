/// HTTP Methods constants
class HttpMethod {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String patch = 'PATCH';
  static const String delete = 'DELETE';
  static const String head = 'HEAD';
  static const String options = 'OPTIONS';

  // Prevent instantiation
  HttpMethod._();
}

/// HTTP Status Codes constants
class HttpStatusCode {
  // Informational (1xx)
  static const int continue_ = 100;
  static const int switchingProtocols = 101;
  static const int processing = 102;

  // Success (2xx)
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int nonAuthoritativeInformation = 203;
  static const int noContent = 204;
  static const int resetContent = 205;
  static const int partialContent = 206;
  static const int multiStatus = 207;
  static const int alreadyReported = 208;
  static const int imUsed = 226;

  // Redirection (3xx)
  static const int multipleChoices = 300;
  static const int movedPermanently = 301;
  static const int found = 302;
  static const int seeOther = 303;
  static const int notModified = 304;
  static const int useProxy = 305;
  static const int temporaryRedirect = 307;
  static const int permanentRedirect = 308;

  // Client Error (4xx)
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int paymentRequired = 402;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int notAcceptable = 406;
  static const int proxyAuthenticationRequired = 407;
  static const int requestTimeout = 408;
  static const int conflict = 409;
  static const int gone = 410;
  static const int lengthRequired = 411;
  static const int preconditionFailed = 412;
  static const int payloadTooLarge = 413;
  static const int uriTooLong = 414;
  static const int unsupportedMediaType = 415;
  static const int rangeNotSatisfiable = 416;
  static const int expectationFailed = 417;
  static const int imATeapot = 418;
  static const int misdirectedRequest = 421;
  static const int unprocessableEntity = 422;
  static const int locked = 423;
  static const int failedDependency = 424;
  static const int tooEarly = 425;
  static const int upgradeRequired = 426;
  static const int preconditionRequired = 428;
  static const int tooManyRequests = 429;
  static const int requestHeaderFieldsTooLarge = 431;
  static const int unavailableForLegalReasons = 451;

  // Server Error (5xx)
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
  static const int httpVersionNotSupported = 505;
  static const int variantAlsoNegotiates = 506;
  static const int insufficientStorage = 507;
  static const int loopDetected = 508;
  static const int notExtended = 510;
  static const int networkAuthenticationRequired = 511;

  // Prevent instantiation
  HttpStatusCode._();

  /// Check if status code is informational (1xx)
  static bool isInformational(int statusCode) {
    return statusCode >= 100 && statusCode < 200;
  }

  /// Check if status code is success (2xx)
  static bool isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if status code is redirection (3xx)
  static bool isRedirection(int statusCode) {
    return statusCode >= 300 && statusCode < 400;
  }

  /// Check if status code is client error (4xx)
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if status code is server error (5xx)
  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  /// Get human-readable status code description
  static String getDescription(int statusCode) {
    switch (statusCode) {
      case ok:
        return 'OK';
      case created:
        return 'Created';
      case accepted:
        return 'Accepted';
      case noContent:
        return 'No Content';
      case badRequest:
        return 'Bad Request';
      case unauthorized:
        return 'Unauthorized';
      case forbidden:
        return 'Forbidden';
      case notFound:
        return 'Not Found';
      case methodNotAllowed:
        return 'Method Not Allowed';
      case conflict:
        return 'Conflict';
      case unprocessableEntity:
        return 'Unprocessable Entity';
      case tooManyRequests:
        return 'Too Many Requests';
      case internalServerError:
        return 'Internal Server Error';
      case notImplemented:
        return 'Not Implemented';
      case badGateway:
        return 'Bad Gateway';
      case serviceUnavailable:
        return 'Service Unavailable';
      case gatewayTimeout:
        return 'Gateway Timeout';
      default:
        return 'Unknown Status Code';
    }
  }
}

/// HTTP Content Types constants
class HttpContentType {
  static const String json = 'application/json';
  static const String formUrlEncoded = 'application/x-www-form-urlencoded';
  static const String multipartFormData = 'multipart/form-data';
  static const String textPlain = 'text/plain';
  static const String textHtml = 'text/html';
  static const String applicationXml = 'application/xml';
  static const String textXml = 'text/xml';
  static const String applicationOctetStream = 'application/octet-stream';
  static const String imageJpeg = 'image/jpeg';
  static const String imagePng = 'image/png';
  static const String imageGif = 'image/gif';
  static const String videoMp4 = 'video/mp4';
  static const String audioMpeg = 'audio/mpeg';

  // Prevent instantiation
  HttpContentType._();
}

/// HTTP Header Names constants
class HttpHeader {
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String acceptLanguage = 'Accept-Language';
  static const String acceptEncoding = 'Accept-Encoding';
  static const String userAgent = 'User-Agent';
  static const String cacheControl = 'Cache-Control';
  static const String expires = 'Expires';
  static const String lastModified = 'Last-Modified';
  static const String etag = 'ETag';
  static const String ifNoneMatch = 'If-None-Match';
  static const String ifModifiedSince = 'If-Modified-Since';
  static const String location = 'Location';
  static const String setCookie = 'Set-Cookie';
  static const String cookie = 'Cookie';
  static const String xRequestedWith = 'X-Requested-With';
  static const String xApiKey = 'X-API-Key';

  // Prevent instantiation
  HttpHeader._();
}

