import 'dart:async';
import 'stub_html.dart' if (dart.library.html) 'dart:html' as html;
import 'popup_redirect_resolver.dart';

///popup_redirect_resolver

class PopupRedirectResolverWeb implements PopupRedirectResolver {
  @override
  Future<Map<String, dynamic>?> resolvePopup(String authUrl) async {
    print('Opening popup with URL: $authUrl');
    final completer = Completer<Map<String, dynamic>?>();
    final popup = html.window.open(
      authUrl,
      'Firebase Auth Popup',
      'width=500,height=600,resizable,scrollbars=yes,status=1',
    );

    void listener(html.Event event) {
      if (event is html.MessageEvent) {
        print('Received message event: ${event.data}');
        try {
          final data = event.data;
          if (data is Map<String, dynamic> &&
              data['type'] == 'authorization_response') {
            html.window.removeEventListener('message', listener);
            completer.complete(data['response']);
          } else {
            print('Invalid message format: $data');
          }
        } catch (e) {
          print('Error parsing message data: $e');
        }
      }
    }

    html.window.addEventListener('message', listener);

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (popup?.closed == true) {
        print('Popup closed');
        timer.cancel();
        html.window.removeEventListener('message', listener);
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      }
    });

    return completer.future;
  }
}
