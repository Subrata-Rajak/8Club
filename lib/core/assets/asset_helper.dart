import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Helper class for asset operations
class AssetHelper {
  /// Load image asset
  static Image image(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }

  /// Load image as widget with error handling
  static Widget imageWidget(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    Widget? errorWidget,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const SizedBox.shrink();
      },
    );
  }

  /// Load asset as bytes
  static Future<ByteData> loadBytes(String path) async {
    return await rootBundle.load(path);
  }

  /// Check if asset exists
  static Future<bool> exists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }
}

