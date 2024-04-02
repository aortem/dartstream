// lib/src/ds_internal_middleware.dart
part of '../ds_shelf.dart';

shelf.Middleware myCustomMiddleware() {
  return (shelf.Handler handler) {
    return (shelf.Request request) {
      // Middleware logic before calling the handler
      final modifiedRequest = request.change(context: {'foo': 'bar'});

      return handler(modifiedRequest).then((response) {
        // Modify the response or perform actions after the handler call
        return response;
      });
    };
  };
}
