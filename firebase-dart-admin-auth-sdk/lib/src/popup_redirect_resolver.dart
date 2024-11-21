import 'dart:async';

///popup redirect

abstract class PopupRedirectResolver {
  ///resolve popup
  Future<Map<String, dynamic>?> resolvePopup(String authUrl);
}

///popup redirect

class PopupRedirectResolverStub implements PopupRedirectResolver {
  @override
  Future<Map<String, dynamic>?> resolvePopup(String authUrl) async {
    throw UnimplementedError(
        'PopupRedirectResolver.resolvePopup() must be implemented by a platform-specific class.');
  }
}
