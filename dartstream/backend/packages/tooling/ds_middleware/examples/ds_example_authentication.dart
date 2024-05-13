import 'package:ds_custom_middleware/ds_custom_middleware.dart';

class DsCustomMiddleWareAuthenticationMiddleware implements dsCustomMiddleware {
  final List<String> authenticatedUsers;

  DsCustomMiddleWareAuthenticationMiddleware(this.authenticatedUsers);

  @override
  Future<DsCustomMiddleWareResponse> handle(
      DsCustomMiddleWareRequest request,
      Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest)
          next) async {
    // Check if the request requires authentication
    if (!request.uri.path.startsWith('/public')) {
      // Check if the user is authenticated
      if (isAuthenticated(request)) {
        // If authenticated, pass the request to the next middleware or handler function
        return await next(request);
      } else {
        // If not authenticated, return a 401 Unauthorized response
        return DsCustomMiddleWareResponse.unauthorized();
      }
    }

    // If the request does not require authentication, pass it to the next middleware or handler function
    return await next(request);
  }

  bool isAuthenticated(DsCustomMiddleWareRequest request) {
    // Extract user information from the request (e.g., from headers, tokens, etc.)
    // For simplicity, we're assuming authentication based on the presence of a token in the request headers
    String? token = request.headers['Authorization'];

    // Check if the token belongs to an authenticated user
    return token != null && authenticatedUsers.contains(token);
  }
}
