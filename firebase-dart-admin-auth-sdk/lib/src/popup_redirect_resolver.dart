import 'dart:async';

abstract class PopupRedirectResolver {
  Future<Map<String, dynamic>?> resolvePopup(String authUrl);
}

class PopupRedirectResolverStub implements PopupRedirectResolver {
  @override
  Future<Map<String, dynamic>?> resolvePopup(String authUrl) async {
    throw UnimplementedError(
        'PopupRedirectResolver.resolvePopup() must be implemented by a platform-specific class.');
  }
}
