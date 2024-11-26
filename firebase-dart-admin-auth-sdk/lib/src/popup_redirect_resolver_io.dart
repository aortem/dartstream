import 'popup_redirect_resolver.dart';

///popup_redirect_resolver

class PopupRedirectResolverIO implements PopupRedirectResolver {
  @override
  Future<Map<String, dynamic>?> resolvePopup(String authUrl) async {
    throw UnimplementedError(
        'PopupRedirectResolver.resolvePopup() is not implemented for IO platforms.');
  }
}
