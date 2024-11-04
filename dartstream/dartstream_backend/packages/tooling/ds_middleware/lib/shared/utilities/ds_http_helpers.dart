import 'dart:io';
import 'dart:convert';
import 'package:ds_custom_middleware/app/models/ds_custom_middleware_model.dart';

class DsHttpHelpers {
  static DsCustomMiddleWareResponse redirect(String location,
      {int statusCode = 302}) {
    return DsCustomMiddleWareResponse(
      statusCode,
      {'Location': location},
      null,
    );
  }

  static DsCustomMiddleWareResponse json(dynamic data, {int statusCode = 200}) {
    return DsCustomMiddleWareResponse(
      statusCode,
      {'Content-Type': 'application/json'},
      jsonEncode(data),
    );
  }

  static Future<DsCustomMiddleWareResponse> sendFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      final contentType = _getContentType(path);
      return DsCustomMiddleWareResponse(
        200,
        {'Content-Type': contentType},
        bytes,
      );
    } else {
      return DsCustomMiddleWareResponse(404, {}, 'File not found');
    }
  }

  static String _getContentType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'html':
        return 'text/html';
      case 'css':
        return 'text/css';
      case 'js':
        return 'application/javascript';
      case 'json':
        return 'application/json';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }

  static Map<String, String> parseCookies(String cookieString) {
    return cookieString.split(';').fold({},
        (Map<String, String> acc, String cookie) {
      final parts = cookie.trim().split('=');
      if (parts.length == 2) acc[parts[0]] = parts[1];
      return acc;
    });
  }

  static String setCookie(
    String name,
    String value, {
    DateTime? expires,
    int? maxAge,
    String? domain,
    String? path,
    bool secure = false,
    bool httpOnly = false,
  }) {
    final parts = <String>['$name=$value'];
    if (expires != null) parts.add('Expires=${HttpDate.format(expires)}');
    if (maxAge != null) parts.add('Max-Age=$maxAge');
    if (domain != null) parts.add('Domain=$domain');
    if (path != null) parts.add('Path=$path');
    if (secure) parts.add('Secure');
    if (httpOnly) parts.add('HttpOnly');
    return parts.join('; ');
  }
}
