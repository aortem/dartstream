import 'dart:convert';
import 'package:shelf/shelf.dart';

/// Middleware that parses the request body based on the Content-Type header.
///
/// Supports:
/// - application/json: Parses as JSON and stores in context['ds_shelf.body']
/// - application/x-www-form-urlencoded: Parses as form data and stores in context['ds_shelf.body']
/// - text/plain: Reads as string and stores in context['ds_shelf.body']
///
/// Stores the parsed body in `request.context['ds_shelf.body']`.
/// Restores the body stream so downstream middleware/handlers can read it again if needed.
Middleware dsShelfBodyParserMiddleware() {
  return (Handler inner) {
    return (Request request) async {
      // Skip body parsing for methods that typically don't have a body
      if (request.method == 'GET' || request.method == 'HEAD' || request.method == 'OPTIONS') {
        return inner(request);
      }

      final contentTypeHeader = request.headers['content-type'];
      if (contentTypeHeader == null) {
        return inner(request);
      }

      final contentType = contentTypeHeader.toLowerCase();

      try {
        if (contentType.contains('application/json')) {
          final content = await request.readAsString();
          // If content is empty, jsonDecode throws. Handle empty body gracefully if needed,
          // but strictly JSON parser expects valid JSON.
          if (content.isEmpty) {
             return inner(request); 
          }
          final body = jsonDecode(content);
          return inner(request.change(
            body: content,
            context: {'ds_shelf.body': body},
          ));
        } else if (contentType.contains('application/x-www-form-urlencoded')) {
          final content = await request.readAsString();
           if (content.isEmpty) {
             return inner(request); 
          }
          final body = Uri.splitQueryString(content);
           return inner(request.change(
            body: content,
            context: {'ds_shelf.body': body},
          ));
        } else if (contentType.contains('text/plain')) {
          final content = await request.readAsString();
           return inner(request.change(
            body: content,
            context: {'ds_shelf.body': content},
          ));
        } else if (contentType.contains('multipart/form-data')) {
           // Multipart parsing allows for more complex handling and typically requires
           // a specific library like `mime` or `http_parser` and streaming.
           // For now we pass through.
           return inner(request);
        }
      } catch (e) {
        return Response.badRequest(body: 'Invalid request body');
      }

      return inner(request);
    };
  };
}
