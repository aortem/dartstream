import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:math' show pow, log;
import 'package:flutter/material.dart';

/// Utility functions for Flutter web implementation.
/// Provides commonly used web-specific utilities and helper functions.
class DSWebUtilities {
  // Private constructor to prevent instantiation
  DSWebUtilities._();

  /// Browser and Platform Detection ===========================================

  /// Checks if code is running in web browser
  static bool get isWebBrowser => identical(0, 0.0);

  /// Gets current browser name
  static String getBrowserName() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('firefox')) return 'Firefox';
    if (userAgent.contains('chrome')) return 'Chrome';
    if (userAgent.contains('safari')) return 'Safari';
    if (userAgent.contains('edge')) return 'Edge';
    if (userAgent.contains('opera')) return 'Opera';
    return 'Unknown Browser';
  }

  /// Gets browser version
  static String getBrowserVersion() {
    return html.window.navigator.appVersion;
  }

  /// URL and Navigation Utilities ============================================

  /// Gets current URL
  static String getCurrentUrl() {
    return html.window.location.href;
  }

  /// Gets base URL without query parameters
  static String getBaseUrl() {
    final uri = Uri.parse(html.window.location.href);
    return uri.origin + uri.path;
  }

  /// Gets specific query parameter from URL
  static String getQueryParam(String param) {
    return Uri.base.queryParameters[param] ?? '';
  }

  /// Gets all query parameters as Map
  static Map<String, String> getAllQueryParams() {
    return Uri.base.queryParameters;
  }

  /// Builds URL with query parameters
  static String buildUrl(String baseUrl, Map<String, String> params) {
    final uri = Uri.parse(baseUrl);
    final newParams = Map<String, String>.from(uri.queryParameters)
      ..addAll(params);
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: uri.path,
      queryParameters: newParams,
    ).toString();
  }

  /// Storage Utilities =====================================================

  /// Saves data to local storage
  static Future<void> saveToLocalStorage(String key, String value) async {
    html.window.localStorage[key] = value;
  }

  /// Gets data from local storage
  static String? getFromLocalStorage(String key) {
    return html.window.localStorage[key];
  }

  /// Removes data from local storage
  static void removeFromLocalStorage(String key) {
    html.window.localStorage.remove(key);
  }

  /// Clears all local storage
  static void clearLocalStorage() {
    html.window.localStorage.clear();
  }

  /// Session storage utilities
  static Future<void> saveToSessionStorage(String key, String value) async {
    html.window.sessionStorage[key] = value;
  }

  /// Gets data from session storage
  static String? getFromSessionStorage(String key) {
    return html.window.sessionStorage[key];
  }

  /// Device and Screen Utilities ==========================================

  /// Checks if running on mobile browser
  static bool get isMobileDevice {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone');
  }

  /// Gets device pixel ratio
  static num get devicePixelRatio {
    return html.window.devicePixelRatio;
  }

  /// Gets screen dimensions
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Gets viewport dimensions
  static Size getViewportSize() {
    return Size(
      html.window.innerWidth?.toDouble() ?? 0,
      html.window.innerHeight?.toDouble() ?? 0,
    );
  }

  /// Responsive Design Utilities =========================================

  /// Checks if screen is small (mobile)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Checks if screen is medium (tablet)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  /// Checks if screen is large (desktop)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  /// Gets responsive value based on screen size
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isSmallScreen(context)) return mobile;
    if (isMediumScreen(context)) return tablet;
    return desktop;
  }

  /// Format Utilities ==================================================

  /// Formats file size
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  /// Formats date for display
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Formats currency
  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  /// Performance Utilities ============================================

  /// Debounces a function
  static Timer? _debounceTimer;

  /// Debounces a function
  static void debounce(
    Function() func, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, func);
  }

  /// Throttles a function
  static DateTime? _throttleTime;

  /// Throttles a function
  static void throttle(
    Function() func, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final now = DateTime.now();
    if (_throttleTime == null || now.difference(_throttleTime!) > duration) {
      func();
      _throttleTime = now;
    }
  }

  /// Clipboard Utilities =============================================

  /// Copies text to clipboard
  static Future<void> copyToClipboard(String text) async {
    await html.window.navigator.clipboard?.writeText(text);
  }

  /// Gets text from clipboard
  static Future<String> getFromClipboard() async {
    return await html.window.navigator.clipboard?.readText() ?? '';
  }

  /// Download Utilities ============================================

  /// Triggers file download
  static void downloadFile(String url, String filename) {}

  /// Downloads data as file
  static void downloadData(List<int> bytes, String filename) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    downloadFile(url, filename);
    html.Url.revokeObjectUrl(url);
  }

  /// Security Utilities ===========================================

  /// Sanitizes HTML string
  static String sanitizeHtml(String html) {
    // Basic HTML sanitization
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Encodes data for XSS prevention
  static String encodeXss(String data) {
    return htmlEscape.convert(data);
  }
}

/// Extension methods for BuildContext
extension WebContextExtensions on BuildContext {
  /// Screen size utilities
  bool get isSmallScreen => DSWebUtilities.isSmallScreen(this);

  /// Screen size utilities
  bool get isMediumScreen => DSWebUtilities.isMediumScreen(this);

  /// Screen size utilities
  bool get isLargeScreen => DSWebUtilities.isLargeScreen(this);

  /// Screen size utilities
  Size get screenSize => DSWebUtilities.getScreenSize(this);

  /// Responsive value getter
  T getResponsiveValue<T>({
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    return DSWebUtilities.getResponsiveValue(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
