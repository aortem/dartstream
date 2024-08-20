import 'dart:async';
import 'dart:html' as html;

class PopupRedirectResolver {
  static const int POPUP_WIDTH = 500;
  static const int POPUP_HEIGHT = 600;

  Future<Map<String, dynamic>> resolvePopup(String authUrl) async {
    final popup = _openPopup(authUrl);
    return await _waitForPopupResult(popup);
  }

  html.WindowBase _openPopup(String url) {
    final left = (html.window.screen!.available.width! - POPUP_WIDTH) ~/ 2;
    final top = (html.window.screen!.available.height! - POPUP_HEIGHT) ~/ 2;

    return html.window.open(
      url,
      'authPopup',
      'width=$POPUP_WIDTH,height=$POPUP_HEIGHT,left=$left,top=$top',
    );
  }

  Future<Map<String, dynamic>> _waitForPopupResult(html.WindowBase popup) {
    final completer = Completer<Map<String, dynamic>>();

    void listener(html.Event event) {
      if (event is html.MessageEvent) {
        final data = event.data;
        if (data is Map<String, dynamic> &&
            data.containsKey('type') &&
            data['type'] == 'auth_result') {
          html.window.removeEventListener('message', listener);
          completer.complete(data);
        }
      }
    }

    html.window.addEventListener('message', listener);

    // Check if the popup is closed
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (popup.closed == true) {
        timer.cancel();
        html.window.removeEventListener('message', listener);
        completer.completeError('Popup closed by user');
      }
    });

    return completer.future;
  }

  Future<Map<String, dynamic>> resolveRedirect() async {
    final completer = Completer<Map<String, dynamic>>();

    void listener(html.Event event) {
      if (event is html.MessageEvent) {
        final data = event.data;
        if (data is Map<String, dynamic> &&
            data.containsKey('type') &&
            data['type'] == 'auth_result') {
          html.window.removeEventListener('message', listener);
          completer.complete(data);
        }
      }
    }

    html.window.addEventListener('message', listener);

    // Wait for redirect result
    Timer(Duration(seconds: 30), () {
      html.window.removeEventListener('message', listener);
      completer.completeError('Redirect timeout');
    });

    return completer.future;
  }
}
